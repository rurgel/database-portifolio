SELECT region,
       sum(population) AS population
FROM "populationdb"."population"
GROUP BY region
ORDER BY population DESC;