#' Simulated ESM Data Set
#'
#' Mimic the structure of a dataset from a heterosexual romantic couples study (i.e., ESM dyadic design).
#' This simulated study focuses on the emotional affect dynamics of romantic partners taking into account
#' the context (location and contact with the partner). In addition, this study assumes that couples are
#' randomized into two treatments. Thus, the dataset includes a baseline phase and a treatment phase,
#' where couples are randomly allocated to one of the two treatments. Here are the general characteristics
#' of the dataset.
#' More information on: <https://preprocess.esmtools.com/terminology.html/>
#'
#' @format
#' A data frame with 4200 rows and 18 columns:
#' \describe{
#'   \item{dyad}{Dyad identification number}
#'   \item{id}{Participant identification number}
#'   \item{role}{Role of a participant within a dyad (make the partner distinguishable)}
#'   \item{age}{Age of the participant}
#'   \item{cond_dyad}{Treatment condition to which the dyad was assigned, as follows: 0=control group and 1=experimental group}
#'   \item{obsno}{ESM questionnaire (beep) number of the observation that indicates their serial order}
#'   \item{scheduled}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was scheduled}
#'   \item{sent}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was sent}
#'   \item{start}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was opened by the participant}
#'   \item{end}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was item ended by the participant}
#'   \item{PA1}{A positive affect (PA) item with a slider scale (1-100)}
#'   \item{PA2}{A positive affect (PA) item with a slider scale (1-100)}
#'   \item{PA3}{A positive affect (PA) item with a slider scale (1-100)}
#'   \item{NA1}{A negative affect (NA) item with a slider scale (1-100)}
#'   \item{NA2}{A negative affect (NA) item with a slider scale (1-100)}
#'   \item{NA3}{A negative affect (NA) item with a slider scale (1-100)}
#'   \item{location}{Categorical item with 4 possible answers (home, work, public space, other)}
#'   \item{contact}{Dichotomous item (1=contact, 0=no contact)}
#' }
"esmdata_sim"




#' Raw ESM data set
#'
#' Raw dataset from a pilot ESM study.
#' This dataset has undergone random value alterations to ensure privacy and cannot be utilized for formal research purposes. 
#' For additional information, refer to the associated article.
#'
#' @format
#' A data frame with 6 rows and 13 columns:
#' \describe{
#'   \item{dyad}{Dyad identification number}
#'   \item{id}{Participant identification number}
#'   \item{role}{Role of a participant within a dyad, indicated by a character (0=father or 1=mother)}
#'   \item{age}{Age of the participant}
#'   \item{scheduled}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was scheduled }
#'   \item{sent}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was sent }
#'   \item{start}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was opened by the participant }
#'   \item{end}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was ended by the participant }
#'   \item{pos_aff}{Positive affect score (0-100)}
#'   \item{neg_aff}{Negative affect score (0-100)}
#'   \item{perc_stress_child}{parents reported if their child did experience a stressful event since the last beep}
#'   \item{perc_fun_child}{parents reported if their child had experienced anything fun since the last beep (yes/no)}
#'   \item{perc_fun_signaled}{parents rated to which extent their child showed they experienced this fun event (0-100)}
#'}
"esmdata_raw"


#' Preprocessed ESM data set
#'
#' This dataset has undergone random value alterations to ensure privacy and cannot be utilized for formal research purposes. 
#' For additional information, refer to the associated article.
#'
#' @format
#' A data frame with 6 rows and 20 columns:
#' \describe{
#'   \item{dyad}{Dyad identification number}
#'   \item{id}{Participant identification number}
#'   \item{role}{Role of a participant within a dyad, indicated by a character (0=father or 1=mother)}
#'   \item{age}{Age of the participant}
#'   \item{compliance}{Participant's proportion of completed surveys}
#'   \item{obsno}{ESM questionnaire (beep) number indicating serial order}
#'   \item{daycum}{Cumulative day count}
#'   \item{beepno}{Beep number within a day}
#'   \item{valid}{Indicator of observation validity (1=valid, 0=invalid)}
#'   \item{scheduled}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was scheduled }
#'   \item{sent}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was sent }
#'   \item{start}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was opened by the participant }
#'   \item{end}{Timestamps (e.g., “2023/04/14 10:23:47”) of when the ESM questionnaire was ended by the participant }
#'   \item{pos_aff}{Positive affect score (0-100)}
#'   \item{neg_aff}{Negative affect score (0-100)}
#'   \item{perc_stress_child}{parents reported if their child did experience a stressful event since the last beep}
#'   \item{perc_fun_child}{parents reported if their child had experienced anything fun since the last beep (yes/no)}
#'   \item{perc_fun_signaled}{parents rated to which extent their child showed they experienced this fun event (0-100)}
#'   \item{pos_aff_pc}{Person-centered positive affect score}
#'   \item{neg_aff_pc}{Person-centered negative affect score}
#'}
"esmdata_preprocessed"
