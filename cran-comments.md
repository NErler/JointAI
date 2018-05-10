# JointAI (version 0.1.0)

---

## Round 1

### Test environments
* local Windows 7, R 3.4.4
* ubuntu 14.04 (on travis-ci), R 3.3.3, R 3.4.4, devel
* win-builder (devel and release)

### R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE

  This is a new release. No additional notes.


### Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

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

--- 

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

* All occurences of `T` and `F` have been replaced by `TRUE` and `FALSE`.

* Removed `\dontrun{}` from all but one example (all examples can be executed
  in <5 seconds). The example still in `\dontrun{}` exports a dataset and writes
  files into a temporary directory.