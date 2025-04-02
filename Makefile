#! add a rule to build the report
Final_Project.html: Final_Project.Rmd Output/table_1.rds Output/graph1.png Code/Render_Final_Report.R
	Rscript Code/Render_Final_Report.R

#! add a rule to create the output of table1
Output/table_1.rds: Code/table1.R
	Rscript Code/table1.R

#! add a rule to create the output of graph1
Output/graph1.png: Code/graph1.R
	Rscript Code/graph1.R

#! add a PHONY target for removing files from output
.PHONY:clean
clean:
	rm Output/*
	