## Test environments

* macOS 12.4 Monterey, R 4.2.1 (2020-10-10) (local)
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (r-hub)
* Ubuntu Linux 16.04 LTS, R-release, GCC (r-hub)
* Fedora Linux, R-devel, clang, gfortran (r-hub)
* Debian Linux, R-devel, GCC ASAN/UBSAN (r-hub)
* Windows Server 2008, R-oldrel (win-builder)
* Windows Server 2008, R-release (win-builder)
* Windows-latest, R-release (r-lib actions)
* Ubuntu 20.04, R-devel (r-lib actions)
* Ubuntu 20.04, R-release (r-lib actions)
* Ubuntu 20.04, R-oldrel (r-lib actions)
* macOS-latest, R-release (r-lib actions)

## R CMD check results

`0 errors | 0 warnings | 0 notes`

## Comments

This is a resubmission (initial release: commit 6476c37). 
We received the following notes when we tested the package:

Fedora Linux, R-devel, clang, gfortran
```
* checking examples ... [26s/51s] NOTE
Examples with CPU (user + system) or elapsed time > 5s
          user system elapsed
journals 2.618  0.003   5.065
```

Ubuntu Linux 20.04.1 LTS, R-release, GCC
* the doi is a valid link
```
* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Alexandra Sarafoglou <alexandra.sarafoglou@gmail.com>’

Found the following (possibly) invalid URLs:
  URL: https://doi.org/10.1037/met0000411
    From: man/binom_bf_equality.Rd
          man/binom_bf_inequality.Rd
          man/binom_bf_informed.Rd
          man/lifestresses.Rd
          man/mult_bf_equality.Rd
          man/mult_bf_inequality.Rd
          man/mult_bf_informed.Rd
          man/mult_tsampling.Rd
          man/peas.Rd
          inst/CITATION
    Status: 403
    Message: Forbidden
```

Windows Server 2008 R2 SP1, R-devel, 32/64 bit
```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

## Changes to version 1.1.0:

- Bug fixes: The null model now constrains all category proportions to be equal. In previous versions, the null model constrained only the category proportions to be equal that were included in the informed hypothesis, leaving the other category proportions free to vary.

- Added feature: The output of the S3 method summary now included the log marginal likelihoods of the encompassing model, the null model, and the informed model. 

