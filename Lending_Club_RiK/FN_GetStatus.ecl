IMPORT $;
IMPORT ML_Core;
IMPORT LogisticRegression AS LR;

// Função de predição de preços de imóveis
EXPORT FN_GetStatus(all_util, annual_inc, dti, 
						fico_range_low, loan_amnt, mort_acc, 
						tax_liens) := FUNCTION

		// Transformação dos parâmetros de entrada no formato de ML data frame				
		myInSet := [all_util, annual_inc, dti, 
					fico_range_low, loan_amnt, mort_acc, 
					tax_liens];
		myInDs := DATASET(myInSet, {UNSIGNED1 loan_status});
		ML_Core.Types.NumericField PrepData(RECORDOF(myInDS) Le, INTEGER C) := TRANSFORM
				SELF.wi 		:= 1,
				SELF.id		 	:= 1,
				SELF.number := C,
				SELF.value 	:= Le.loan_status;
		END;
		myIndepData := PROJECT(myInDs, PrepData(LEFT,COUNTER));
		
		// Predição e retorno do valor do imóvel consultado
		myModel := DATASET('~mymodelLRRIK',ML_Core.Types.Layout_Model2,FLAT,PRELOAD); //Substitua XXX pelas iniciais do seu nome completo
		myLearner := LR.BinomialLogisticRegression();
		myPredictDeps := MyLearner.Classify(myModel, myIndepData);
	
		RETURN OUTPUT(myPredictDeps,{loan_status:=value});
		
END;
