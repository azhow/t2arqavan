make
rm ./results.csv
echo "program,input,execution,time_ms" >> ./results.csv
for program in ./bin/*
do
	for input in ./input/*
	do
		for i in {1..30}
		do
			RESULT_MS=$(program input)
			echo "$program,$input,$i,$RESULT_MS" >> ./results.csv
		done
	done
done
