##run_analysis.R
## Leemos los ficheros de test (cabeceras, id_actividad, id_sujeto, variables) y los juntamos. 
## Aprovechamos también para quedarnos sólo los las features que queremos, osea los de medias y desviaciones
## luego haremos lo mismo con los de train
## Y por último los uniremos
#dataDir <- "UCI HAR Dataset"
testDir <- "test"
trainDir <- "train"

# Voy a leer el listado de Features, para luego seleccionar las que sean de media o desviación
#fCabFeatures <- file.path(dataDir, "features.txt")
fCabFeatures <- "features.txt"
dCabFeatures <- read.table(fCabFeatures)
colnames(dCabFeatures) <- c("feature_id","feature_name")
#creo que tenemos que pasarlo a vector (es un factor)
dCabFeatures$feature_name <- as.vector(dCabFeatures$feature_name)

# we are only interested in those that represent mean (mean) or standard deviation (std):
mis_feat <- sort(union(grep("-mean()",dCabFeatures$feature_name,fixed=TRUE), grep("-std()",dCabFeatures$feature_name,fixed=TRUE)))
# Their names; we will use them as variable names, column names:
nom_col <- c("activ_id","subject_id","group",dCabFeatures$feature_name[mis_feat])

# Train files and test files are equivalent, so we will read them 
resultados_grupo <- function ( ruta_sujetos, ruta_actividades, ruta_features, grupo) {
    # Subject who made the experiment:
    dSujetos <- read.table(ruta_sujetos)
    # Activity he was doing:
    dActiv <- read.table(ruta_actividades)
    # group <- "test" # (test / train)

	# Results file, variables
	dFeatures <- read.table(ruta_features)  
	# We are interested just in some variables:
	dMedidas <- dFeatures[,mis_feat]
	
	# All the information together
	dDatos <- cbind(dActiv,dSujetos,grupo,dMedidas)
	colnames(dDatos) <- nom_col
	dDatos 
}

# Test files:
fSujetosTest <- file.path(testDir, "subject_test.txt")
fActivTest <- file.path(testDir, "y_test.txt")
fFeaturesTest <- file.path(testDir, "X_test.txt")
# Train files
fSujetosTrain <- file.path(trainDir, "subject_train.txt")
fActivTrain <- file.path(trainDir, "y_train.txt")
fFeaturesTrain <- file.path(trainDir, "X_train.txt")

# Test results
test_data <- resultados_grupo( fSujetosTest, fActivTest, fFeaturesTest, "test")
# Train results
train_data <- resultados_grupo( fSujetosTrain, fActivTrain, fFeaturesTrain, "train")

# Train & Test data
data <- rbind(test_data, train_data)

# we don't need this any more:
rm("test_data")
rm("train_data")

# Activity names
#fCatalogoActiv <- file.path(dataDir, "activity_labels.txt")
fCatalogoActiv <- "activity_labels.txt"
dCatalogoActv <- read.table(fCatalogoActiv)
colnames(dCatalogoActv) <- c("activ_id","activity")

# Results dataset (point 4):
res4 <- merge(dCatalogoActv,data,by.x="activ_id",by.y="activ_id")

# We need dplyr package: install.packages("dplyr")
library(dplyr)

# Final result:
res5 <- res4 %>% select(-activ_id,-group) %>%   # we don't want activity_id nor group columns for this analysis
    group_by(activity,subject_id)  %>%          # group by activity and subject
    summarise_each(funs(mean))                  # and get the mean of all variables
