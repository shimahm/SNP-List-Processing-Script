## SNP List Processing Script

This R script processes a list of SNPs by chromosome and position, runs a block LD plotting command for each SNP, and records the results in an output file.

### Steps:

1. **Load SNP List**
   - Reads SNP information (chromosome and position) from a tab-delimited file `snp_chr_pos.txt` into a dataframe.

   ```r
   snp_list <- read.table("snp_chr_pos.txt", header = TRUE, stringsAsFactors = FALSE)
   ```

2. **Create Output File**
   - Initializes an output file `snp_results.txt` and writes the header line.

   ```r
   output_file <- "snp_results.txt"
   writeLines("chr\tpos\tstatus", output_file)
   ```

3. **Loop Through Each SNP**
   - Iterates through each SNP entry (row) in the dataframe.

   ```r
   for (i in 1:nrow(snp_list)) {
     chr <- snp_list$chr[i]
     pos <- snp_list$pos[i]
   ```

4. **Build and Run Command**
   - Constructs a command to run an external R script (`plot_block_ld.R`) with the chromosome and position as arguments.
   - Executes the command and captures its output.

   ```r
     cmd <- paste("Rscript plot_block_ld.R", chr, pos)
     result <- tryCatch({
       output <- system(cmd, intern = TRUE)
   ```

5. **Check Command Output**
   - Scans the output for the string `"No haplotype block found"` to determine success.
   - Assigns a status:
     - `"NO"` if no block is found
     - `"OK"` if successful
     - `"ERROR"` if there is an exception

   ```r
       if (any(grepl("No haplotype block found", output))) {
         status <- "NO"
       } else {
         status <- "OK"
       }
       status
     }, error = function(e) {
       "ERROR"
     })
   ```

6. **Write Result to Output File**
   - Appends the chromosome, position, and status for each SNP to the output file.

   ```r
     line <- paste(chr, pos, result, sep = "\t")
     write(line, file = output_file, append = TRUE)
   }
   ```

---

### Output Example (`snp_results.txt`):

```
chr	pos	status
1	123456	OK
2	234567	NO
3	345678	ERROR
...
```

- **chr**: Chromosome number
- **pos**: Position
- **status**: Result of LD block plotting (`OK`, `NO`, or `ERROR`)
