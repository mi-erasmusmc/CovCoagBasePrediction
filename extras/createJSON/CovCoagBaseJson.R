# code to create the json prediction:
webApi = 'https://awsagunva1011.jnj.com:8443/WebAPI'

populationSettings <- list(PatientLevelPrediction::createStudyPopulationSettings(riskWindowEnd = 30,
                                                                                 riskWindowStart = 1,
                                                                                 washoutPeriod = 365,
                                                                                 removeSubjectsWithPriorOutcome = TRUE,
                                                                                 firstExposureOnly = TRUE,
                                                                                 priorOutcomeLookback = 99999,
                                                                                 requireTimeAtRisk = FALSE),
                           PatientLevelPrediction::createStudyPopulationSettings(riskWindowEnd = 60,
                                                                                 riskWindowStart = 1,
                                                                                 washoutPeriod = 365,
                                                                                 removeSubjectsWithPriorOutcome = TRUE,
                                                                                 firstExposureOnly = TRUE,
                                                                                 priorOutcomeLookback = 99999,
                                                                                 requireTimeAtRisk = FALSE),
                           PatientLevelPrediction::createStudyPopulationSettings(riskWindowEnd = 90,
                                                                                 riskWindowStart = 1,
                                                                                 washoutPeriod = 365,
                                                                                 removeSubjectsWithPriorOutcome = TRUE,
                                                                                 firstExposureOnly = TRUE,
                                                                                 priorOutcomeLookback = 99999,
                                                                                 requireTimeAtRisk = FALSE))


modelList <- list(list("LassoLogisticRegressionSettings" = list("variance" = 0.01)))

covariateSettings <- list(list(list(fnct = 'createCovariateSettings',
                                    settings = FeatureExtraction::createCovariateSettings(useDemographicsGender = T,
                                                                                          useDemographicsAge = T)))
)

resrictOutcomePops <- NULL
resrictModelCovs <- NULL

executionSettings <- list(minCovariateFraction = 0.000,
                          normalizeData = T,
                          testSplit = "stratified",
                          testFraction = 0.20,
                          splitSeed = 1000,
                          nfold = 3)

json <- createDevelopmentStudyJson(packageName = 'CovCoagBasePrediction',
                           packageDescription = 'Prediction model based on predictors proposed by the EMA',
                           createdBy = 'Henrik John',
                           organizationName = 'Erasmus University Medical Center',
                           targets = data.frame(targetId = c(22710,22709,22708,22707),
                                                cohortId = c(22710,22709,22708,22707),
                                                targetName = c('COVID19 positive test',
                                                               'COVID19 diagnosis narrow',
                                                               'COVID19 diagnosis broad',
                                                               'COVID19 PCR positive test')),
                           outcomes = data.frame(outcomeId = c(22601,22600,22599,22595,22596,22602),
                                                 cohortId = c(22601,22600, 22599,22595,22596,22602),
                                                 outcomeName = c('MI','IS','MI_and_IS','PE','DVT_narrow',
                                                                 'VTE_narrow')),
                           populationSettings = populationSettings,
                           modelList = modelList,
                           covariateSettings = covariateSettings,
                           resrictOutcomePops = resrictOutcomePops,
                           resrictModelCovs = resrictModelCovs,
                           executionSettings = executionSettings,
                           webApi = webApi,
                           outputLocation = 'D:/hjohn/CovCoagBase',
                           jsonName = 'predictionAnalysisList.json')

specifications <- Hydra::loadSpecifications(file.path('D:/hjohn/CovCoagBase', 'predictionAnalysisList.json'))
Hydra::hydrate(specifications = specifications, outputFolder = 'D:/hjohn/CovCoagBase/CovCoagBasePrediction')
