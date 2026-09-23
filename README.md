# Y-chromosome ampliconic gene expression: RBMY, TSPY, and DAZ

Long-read (PacBio Iso-Seq) analysis of testis transcripts from the multi-copy, male-specific Y-chromosome gene families **RBMY**, **TSPY**, and **DAZ**. The workflow pulls reads belonging to these families, maps them to T2T-CHM13v2.0 chrY and to 140 individual chrY assemblies, tests whether a pangenome assembly represents these genes better than the T2T reference, and reconstructs DAZ transcript exon structures with RepeatMasker.

All scripts use absolute paths on the lab HPC (`/project/mkonkel/tangeno/...`). Update them before running elsewhere.

## Workflow overview

```
refine.sh                               Trim primers / poly-A from raw Iso-Seq reads
   │   (reads then mapped to CHM13; not included here)
   ▼
extractMaleGeneReads.ipynb              Pull reads overlapping non-PAR chrY exons, per gene family
   │
   ├──► rmDAZ.sh                        RepeatMasker DAZ reads against a DAZ exon library
   │       ▼
   │    parseDAZrepeatmasker.ipynb      Reconstruct + plot DAZ exon structures per read / copy
   │
   ▼
extractAssemblyAlignments_v2_All140.ipynb  (part 1) Build the RBMY/TSPY/DAZ read set
   │
   ├──► mapTestis_Assemblies.sh         Map read set to each of the 140 chrY assemblies
   ├──► mapTestis_T2TchrY.sh            Map read set to T2T-CHM13v2.0 chrY
   ▼
extractAssemblyAlignments_v2_All140.ipynb  (part 2) Compare T2T vs assemblies, stats, figures
   │
   ▼
gviz_expressionOverviews.ipynb          Locus-level read pileup figures (Gviz)
```

## Files

### Bash / SLURM scripts

| File | Purpose |
|---|---|
| `refine.sh` | Runs `isoseq refine --require-polya` on converted BAMs to remove Iso-Seq v2 primers and require a poly-A tail. Outputs `*_trimmed.bam`. |
| `rmDAZ.sh` | Runs RepeatMasker with a custom DAZ exon library (`DAZ.fasta`) on the merged DAZ read FASTAs from pooled testis and GENCODE testis data. Output (`DAZrepeatOut_v3/`) is the input to `parseDAZrepeatmasker.ipynb`. |
| `mapTestis_Assemblies.sh` | Loops over all chrY assembly FASTAs and aligns `RBMY_TSPY_DAZ_gencodeReads.fasta` to each with `pbmm2 align --preset ISOSEQ --sort`. One BAM per assembly (`maleGeneReads_<SAMPLE>chrY.bam`). |
| `mapTestis_T2TchrY.sh` | Aligns the same read set(s) to T2T-CHM13v2.0 chrY only (`NC_060948.1`), so the reference comparison is chrY-to-chrY. |

### Notebooks

**`extractMaleGeneReads.ipynb`** (Python)
Builds merged exon intervals for every non-PAR chrY gene from the CHM13 RefSeq GTF, then uses `pysam` (parallelized over BAMs) to collect reads overlapping those exons. Writes one FASTA per gene, then merges copies into gene-family FASTAs (`<FAMILY>_mergedReads.fa`, e.g. trailing copy numbers stripped so DAZ1–4 → DAZ). Sections cover GENCODE testis, great ape testis (per-sample output), pooled testis, and heart/cerebellum. Also includes utility cells for recovering full reads from FASTQ given an aligned FASTA (RBMY1B).

**`parseDAZrepeatmasker.ipynb`** (Python)
Parses RepeatMasker `.out` files for DAZ reads and reconstructs each read's exon order, handling the repeated DAZ exon units (e.g. `2-7-12`, `3-8-13`) and relabeling exons 17–25 as letters (B–Z). Reads are matched against reference exon layouts for DAZ1–DAZ4 and plotted as per-copy transcript-structure figures (PNG/PDF). Also includes a function to flag reads with intron retention. The "Current Preferred Output" section is the version in use; "Previous iterations" is kept for reference.

**`extractAssemblyAlignments_v2_All140.ipynb`** (Python)
Main pangenome-vs-reference comparison.
1. *Read set selection:* GENCODE testis reads mapped to RBMY/TSPY/DAZ gene copies from the 140 assemblies are filtered by best-hit alignment portion, remapped to the HG01358 chrY, filtered again (≥95%), and written to `RBMY_TSPY_DAZ_gencodeReads.fasta`. Also extracts T2T chrY to its own FASTA.
2. *(Run the two `mapTestis_*.sh` scripts.)*
3. *Comparison:* loads alignments to all 140 chrY assemblies plus T2T, parses CIGARs to compute alignment portion (`=` matches / read length), and assigns each read to a gene copy using each sample's combined annotation. Keeps spliced reads with a ≥99% best assembly hit; DAZ reads are further required to contain exon 1 (from RepeatMasker output) to limit 5′ truncation.
4. *Outputs:* mean/median alignment by family, per-sample ranked bar plots (T2T highlighted), T2T vs best-assembly boxplots, one-sided Mann–Whitney U tests with rank-biserial effect size, and gene-copy confusion matrices (T2T vs HG01358, T2T vs HG002, HG01358 vs HG002). Ends with a TSPY1 vs TSPY2 deep dive.

**`gviz_expressionOverviews.ipynb`** (R, Gviz kernel)
Produces locus-level figures combining a genome axis, RefSeq transcripts, repeat annotation (GFF3), and read alignments from splicing-only, deduplicated BAMs. Covers DAZ1–4, TSPY2, and RBMY1D on T2T chrY, plus DAZ/TSPY2 loci on the HG01358, HG00731, and NA20850 assemblies. Writes PDFs to `expressionFigureAlignments/figures/`.

## Dependencies

- **Command line:** `isoseq` (refine), `pbmm2`, RepeatMasker (custom-library build)
- **Python:** pandas, numpy, pysam, biopython, scipy, matplotlib, seaborn, tqdm
- **R / Bioconductor:** Gviz, GenomicRanges, GenomicAlignments, GenomicFeatures, Rsamtools, rtracklayer, IRanges, GenomeInfoDb

## Reference data

- T2T-CHM13v2.0 (RefSeq `GCF_009914755.1`) genome and `genomic.gtf`; chrY = `NC_060948.1`
- 140 chrY assemblies with per-sample combined gene annotations (`<SAMPLE>_combinedAnnotation.<date>.csv`)
- Custom DAZ exon library for RepeatMasker (`DAZ_customExonRepeatmaskerLibrary.fasta`)
