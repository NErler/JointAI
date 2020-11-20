# JointAI (version 1.0.1)

## Round 1

### Test environments
* local Windows 10, R 4.0.3
* windows server x64 (via github actions), R 3.6.3, R 4.0.3
* ubuntu 16.04.7 LTS (via github actions), R 3.6.3, R 4.0.3, devel
* macOS Catalina 10.15.6 (via github actions), R 4.0.3
* win-builder (devel and release)


### R CMD check results

0 errors | 0 warnings | 0 notes

### Reverse dependencies

There are no reverse dependencies.

---

# JointAI (version 1.0.0)

## Round 1

### Test environments
* local Windows 10, R 4.0.2
* windows server x64 (via github actions), R 3.6.3, R 4.0.2
* ubuntu 16.04.7 LTS (via github actions), R 3.6.3, R 4.0.2, devel
* macOS Catalina 10.15.6 (via github actions), R 4.0.2
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes

Note: 

Found the following (possibly) invalid URLs:
  URL: http://mcmc-jags.sourceforge.net
    From: DESCRIPTION
          man/JointAI.Rd
          inst/doc/ModelSpecification.html
          README.md
    Status: 503
    Message: Service Unavailable
  URL: http://mcmc-jags.sourceforge.net/
    From: inst/doc/MCMCsettings.html
          inst/doc/SelectingParameters.html
    Status: 503
    Message: Service Unavailable
    
It seems http://mcmc-jags.sourceforge.net/ is currently not available. This site
is still linked to from the JAGS sourceforge repository
(https://sourceforge.net/projects/mcmc-jags/), in which there were commits
during the last few days. I expect that the site is only offline temporarily.



### Reverse dependencies

There are no reverse dependencies.


### Reviewer comments:
2020-08-28 Uwe Ligges

```
Thanks, we see:

   Found the following (possibly) invalid URLs:
     URL: https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fmcmc-jags.sourceforge.net%2F&amp;data=02%7C01%7Cn.erler%40erasmusmc.nl%7C0c7f767e3a2441d6e91708d84b44fbea%7C526638ba6af34b0fa532a1a511f4ac80%7C0%7C0%7C637342106948860379&amp;sdata=BnQmxD3TVZZhmJsK%2FEXn3VdM0yHnQiXKr%2BKoI2Lnb%2Bk%3D&amp;reserved=0
       From: DESCRIPTION
             man/JointAI.Rd
             inst/doc/ModelSpecification.html
             README.md
       Status: 503
       Message: Service Unavailable
     URL: https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fmcmc-jags.sourceforge.net%2F&amp;data=02%7C01%7Cn.erler%40erasmusmc.nl%7C0c7f767e3a2441d6e91708d84b44fbea%7C526638ba6af34b0fa532a1a511f4ac80%7C0%7C0%7C637342106948860379&amp;sdata=BnQmxD3TVZZhmJsK%2FEXn3VdM0yHnQiXKr%2BKoI2Lnb%2Bk%3D&amp;reserved=0
       From: inst/doc/MCMCsettings.html
             inst/doc/SelectingParameters.html
       Status: 503
       Message: Service Unavailable


Is this site expected to work again?



     URL: https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.rdocumentation.org%2Fpackages%2FJointAI&amp;data=02%7C01%7Cn.erler%40erasmusmc.nl%7C0c7f767e3a2441d6e91708d84b44fbea%7C526638ba6af34b0fa532a1a511f4ac80%7C0%7C0%7C637342106948860379&amp;sdata=PFxlgYV9CUMysfSwpq7WUNi0jDIdFjZ%2FMKkigq0Idj4%3D&amp;reserved=0 (moved to
https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.rdocumentation.org%2Fpackages%2FJointAI&amp;data=02%7C01%7Cn.erler%40erasmusmc.nl%7C0c7f767e3a2441d6e91708d84b44fbea%7C526638ba6af34b0fa532a1a511f4ac80%7C0%7C0%7C637342106948860379&amp;sdata=JUmFeBruGfIyJa6iwkQL%2BzRHlpJEROMCACl49KqyQnU%3D&amp;reserved=0)
       From: README.md
       Status: 200
       Message: OK
     URL: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fnerler.github.io%2FJointAI&amp;data=02%7C01%7Cn.erler%40erasmusmc.nl%7C0c7f767e3a2441d6e91708d84b44fbea%7C526638ba6af34b0fa532a1a511f4ac80%7C0%7C0%7C637342106948860379&amp;sdata=vKboFCbEcw2iztBZCmyquUy90qRk%2Fa24G4L0501FwA4%3D&amp;reserved=0 (moved to
https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fnerler.github.io%2FJointAI%2F&amp;data=02%7C01%7Cn.erler%40erasmusmc.nl%7C0c7f767e3a2441d6e91708d84b44fbea%7C526638ba6af34b0fa532a1a511f4ac80%7C0%7C0%7C637342106948860379&amp;sdata=5qBicSOWF4HDqlmiY5pud%2BkyL0vgMTcCbHm1oi2yZ4w%3D&amp;reserved=0)
       From: DESCRIPTION
       Status: 200
       Message: OK


Please change http --> https  or add trailing slashes where required.


   The Description field should not start with the package name,
     'This package' or similar.

   Size of tarball: 9353082 bytes

Not more than 5 MB for a CRAN package, please.

Please fix and resubmit.
```

## Round 2
### Submission comments
2020-08-29

All comments were addressed, specifically:

* Website http://mcmc-jags.sourceforge.net/ is up again
* URLs were changed to https (except for http://mcmc-jags.sourceforge.net/,
  which does not have a SSL certificate)
* The Description was adjusted (now starts with "Joint analysis and imputation
  of incomplete data...")
* The tarball size was reduced by excluding vignettes from the build and by 
  using a different file format for large output files from `testthat` tests



### Automatic check failure
Under Windows and Debian:

```
Found the following (possibly) invalid URLs:
  URL: https://nerler.github.io/JointAI (moved to https://nerler.github.io/JointAI/)
    From: DESCRIPTION
    Status: 200
    Message: OK
```

## Round 3
### Submission comments
2020-08-30

* With regards to the automatic check:
  a trailing slash was added to the link in the DESCRIPTION
  
* With regards to the current CRAN status (JointAI 0.6.1): ERROR: 1, WARN: 1, NOTE: 1, OK: 9
  * ERROR:
    ```
    Version: 0.6.1
    Check: examples, Result: ERROR
    Running examples in 'JointAI-Ex.R' failed
    ...
    > plot_imp_distr(impDF, id = "id", ncol = 3)
    Error in plot_imp_distr(impDF, id = "id", ncol = 3) : 
      This function requires the package ggpubr to be installed.
    ```
    In JointAI 1.0.0 the function `plot_imp_distr()` does no longer return an 
    error if **ggpubr** is not installed but an informative message.
  * WARNING:
    ```
    Version: 0.6.1
    Check: re-building of vignette outputs, Result: WARNING

    Warning: Using formula(x) is deprecated when x is a character vector of length > 1.
    Consider formula(paste(x, collapse = " ")) instead.
    ```
    This warning is due to a change in R 4.0.0 and was addressed in JointAI 1.0.0
  * NOTE:
    ```
    Version: 0.6.1
    Check: Rd cross-references, Result: NOTE
    Undeclared package ‘ordinal’ in Rd xrefs
    See: <https://www.r-project.org/nosvn/R.check/r-devel-linux-x86_64-fedora-clang/JointAI-00check.html>
    ```
    JointAI 1.0.0 does no longer link to the package **ordinal**.
    
    
---


# JointAI (version 0.6.0)

## Round 1

### Test environments
* local Windows 7, R 3.6.1
* ubuntu 14.04.5 LTS (on travis-ci), R 3.5.3, R 3.6.1, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes


### Reverse dependencies

There are no reverse dependencies.

---


# JointAI (version 0.5.2)

## Round 1

### Test environments
* local Windows 7, R 3.6.0
* ubuntu 14.04.5 LTS (on travis-ci), R 3.5.3, R 3.6.0, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes


### Reverse dependencies

There are no reverse dependencies.

---


# JointAI (version 0.5.1)

## Round 1

### Test environments
* local Windows 7, R 3.6.0
* ubuntu 14.04.5 LTS (on travis-ci), R 3.5.3, R 3.6.0, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes


### Reverse dependencies

There are no reverse dependencies.

---


# JointAI (version 0.5.0)

## Round 1

### Test environments
* local Windows 7, R 3.5.2
* ubuntu 14.04.5 LTS (on travis-ci), R 3.4.4, R 3.5.2, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes


### Reverse dependencies

There are no reverse dependencies.

---


# JointAI (version 0.4.0)

## Round 1

### Test environments
* local Windows 7, R 3.5.1
* ubuntu 14.04.5 LTS (on travis-ci), R 3.4.4, R 3.5.1, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 1 note

#### Note in win-builder R-oldrelease:
Author field differs from that derived from Authors@R\
  Author:    'Nicole S. Erler [aut, cre] (<https://orcid.org/0000-0002-9370-6832>)'\
  Authors@R: 'Nicole S. Erler [aut, cre] (0000-0002-9370-6832)'


### Reverse dependencies

There are no reverse dependencies.

---


# JointAI (version 0.3.0)

## Round 1

### Test environments
* local Windows 7, R 3.5.1
* ubuntu 14.04 (on travis-ci), R 3.4.4, R 3.5.0, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes


### Reverse dependencies

There are no reverse dependencies.

---



# JointAI (version 0.2.0)

## Round 1

### Test environments
* local Windows 7, R 3.5.1
* ubuntu 14.04 (on travis-ci), R 3.4.4, R 3.5.0, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 notes


### Reverse dependencies

There are no reverse dependencies.

---


# JointAI (version 0.1.0)

## Round 1

### Test environments
* local Windows 7, R 3.4.4
* ubuntu 14.04 (on travis-ci), R 3.3.3, R 3.4.4, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 0 note

* checking CRAN incoming feasibility ... NOTE

  This is a new release. No additional notes.


### Reverse dependencies

This is a new release, so there are no reverse dependencies.



### Reviewer comments
2018-03-21 Swetlana Herbrandt

```
Thanks, you have code from the foreign package in your package, hence please add
all authors and copyright holders of foreign in the Authors@R field with the
appropriate roles.

From the CRAN policies you agreed to:

"The ownership of copyright and intellectual property rights of all components
of the package must be clear and unambiguous (including from the authors specification in the DESCRIPTION file). Where code is copied (or derived) from the work of others (including from R itself), care must be taken that any copyright/license statements are preserved and authorship is not misrepresented.

Preferably, an ‘Authors@R’ would be used with ‘ctb’ roles for the authors of such code. Alternatively, the ‘Author’ field should list these authors as contributors.

Where copyrights are held by an entity other than the package authors, this should preferably be indicated via ‘cph’ roles in the ‘Authors@R’ 
field, or using a ‘Copyright’ field (if necessary referring to an inst/COPYRIGHTS file)."


Please do not capitalize "Analysis" and "Imputation" in your description.

Please start your description with "Provides joint analysis and imputation of linear..." or something similar.

Please replace T and F by TRUE and FALSE in your Rd-files and your code.

Most of your examples are wrapped in \dontrun{} and hence not tested. 
Please unwrap the examples if that is feasible and if they can be executed in < 5 sec for each Rd file or create additionally small toy examples. Something like \examples{
        examples for users and checks:
        executable in < 5 sec
        \dontshow{
               examples for checks:
               executable in < 5 sec together with the examples above
               not shown to users
        }
        donttest{
               further examples for users (not used for checks)
        }
}
would be desirable.

Please fix and resubmit.
```

 

## Round 2
### Submission comments
2018-03-21

Addressed all previous comments, specifically:

* It was an oversight that I was still using the code copied from another package.
  I removed the function `write_SPSS` that was using this code.
  Instead I am now using `write.foreign` from the **foreign** package. I have
  added this package to 'Suggests' in the DESCRIPTION file and am linking
  to it in the documentation of the relevant function in my package.
  
* I have made the requested changes in the DESCRIPTION file.

* All occurrences of `T` and `F` have been replaced by `TRUE` and `FALSE`.

* Removed `\dontrun{}` from all but one example (all examples can be executed
  in <5 seconds). The example still in `\dontrun{}` exports a dataset and writes
  files into a temporary directory.


### Reviewer comments
2018-03-22 Swetlana Herbrandt

```
Thanks, on CRAN now.
```
