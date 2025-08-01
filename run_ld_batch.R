# Load SNP list
snp_list <- read.table("snp_chr_pos.txt", header = TRUE, stringsAsFactors = FALSE)

# Create output file
output_file <- "snp_results.txt"
writeLines("chr\tpos\tstatus", output_file)

# Loop through each SNP
for (i in 1:nrow(snp_list)) {
  chr <- snp_list$chr[i]
  pos <- snp_list$pos[i]
  
  # Build command
  cmd <- paste("Rscript plot_block_ld.R", chr, pos)
  
  # Try running the command and capture output
  result <- tryCatch({
    output <- system(cmd, intern = TRUE)
    
    # Check output for success or failure
    if (any(grepl("No haplotype block found", output))) {
      status <- "NO"
    } else {
      status <- "OK"
    }
    
    status
  }, error = function(e) {
    "ERROR"
  })
  
  # Write result to file
  line <- paste(chr, pos, result, sep = "\t")
  write(line, file = output_file, append = TRUE)
}

