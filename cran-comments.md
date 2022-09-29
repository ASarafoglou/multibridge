## Test environments

* macOS 11.1 Big Sur, R 4.0.3 (2020-10-10) (local)
* Ubuntu Linux 16.04 LTS, R-release, GCC (r-hub)
* Fedora Linux, R-devel, clang, gfortran (r-hub)
* Debian Linux, R-devel, GCC ASAN/UBSAN (r-hub)
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (r-hub)
* Windows Server 2008, R-oldrel (win-builder)
* Windows Server 2008, R-release (win-builder)

## R CMD check results

`0 errors | 0 warnings | 2 notes`

## Comments

This is a resubmission (initial release: commit 6476c37). 
We received the following notes when we tested the package:

```
N  checking for GNU extensions in Makefiles
   GNU make is a SystemRequirements.
```

## Changes to version 1.1.0:

- Bug fixes: The null model now constrains all category proportions to be equal. In previous versions, the null model constrained only the category proportions to be equal that were included in the informed hypothesis, leaving the other category proportions free to vary.

- Added feature: The output of the S3 method summary now included the log marginal likelihoods of the encompassing model, the null model, and the informed model. 

