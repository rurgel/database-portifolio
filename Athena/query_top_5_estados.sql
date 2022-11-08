SELECT state,
       sum(population) AS population
FROM "populationdb"."population"
GROUP BY state
ORDER BY population DESC
LIMIT 5;