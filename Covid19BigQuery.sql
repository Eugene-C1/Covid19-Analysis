-- Total cases and deaths per state
SELECT 
  state_name, 
  SUM(confirmed_cases) AS total_confirmed_cases,
  SUM(deaths) AS total_deaths
FROM
  `bigquery-public-data.covid19_nyt.us_states`
GROUP BY
  state_name;

-- Total number of cases and deaths per county
SELECT
  county,
  state_name,
  SUM(confirmed_cases) AS total_confirmed_cases,
  SUM(deaths) AS total_deaths
FROM
  `bigquery-public-data.covid19_nyt.us_counties`
GROUP BY
  county, 
  state_name;

-- Finding the average mask use per county
SELECT 
  a.county, 
  ROUND(AVG(b.never), 2) AS avg_never, 
  ROUND(AVG(b. rarely), 2) AS avg_rarely, 
  ROUND(AVG(b.sometimes), 2) AS avg_sometimes, 
  ROUND(AVG(b.frequently), 2) as avg_frequently
FROM
  `bigquery-public-data.covid19_nyt.us_counties` as a
LEFT JOIN
  `bigquery-public-data.covid19_nyt.mask_use_by_county`as b
ON
  a.county_fips_code = b.county_fips_code
GROUP BY
  a.county;

-- Normalizing the data so that the sum of the averages equals to 1
SELECT 
  a.county, 
  ROUND(AVG(b.never) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_never, 
  ROUND(AVG(b.rarely) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_rarely, 
  ROUND(AVG(b.sometimes) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_sometimes, 
  ROUND(AVG(b.frequently) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_frequently
FROM
  `bigquery-public-data.covid19_nyt.us_counties` as a
LEFT JOIN
  `bigquery-public-data.covid19_nyt.mask_use_by_county`as b
ON
  a.county_fips_code = b.county_fips_code
GROUP BY
  a.county;

-- Finding the average mask use per state
SELECT 
  a.state_name, 
  ROUND(AVG(b.never), 2) AS avg_never, 
  ROUND(AVG(b. rarely), 2) AS avg_rarely, 
  ROUND(AVG(b.sometimes), 2) AS avg_sometimes, 
  ROUND(AVG(b.frequently), 2) as avg_frequently
FROM
  `bigquery-public-data.covid19_nyt.us_counties` as a
LEFT JOIN
  `bigquery-public-data.covid19_nyt.mask_use_by_county`as b
ON
  a.county_fips_code = b.county_fips_code
GROUP BY
  a.state_name;

-- Normalizing the data so that the sum of the averages equals to 1
SELECT 
  a.state_name, 
  ROUND(AVG(b.never) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_never, 
  ROUND(AVG(b.rarely) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_rarely, 
  ROUND(AVG(b.sometimes) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_sometimes, 
  ROUND(AVG(b.frequently) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_frequently
FROM
  `bigquery-public-data.covid19_nyt.us_counties` as a
LEFT JOIN
  `bigquery-public-data.covid19_nyt.mask_use_by_county`as b
ON
  a.county_fips_code = b.county_fips_code
GROUP BY
  a.state_name;

-- Find the death rate per state
SELECT
  state_name,
  SUM(confirmed_cases) AS total_cases,
  SUM(deaths) AS total_deaths,
  ((SUM(deaths) / SUM(confirmed_cases)) * 100) AS fatality_rate
FROM
  `bigquery-public-data.covid19_nyt.us_states`
GROUP BY
  state_name;

-- Finding the correlation of using a mask and the fatality rate
SELECT
  a.state_name,
  ROUND(AVG(b.never) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_never, 
  ROUND(AVG(b.rarely) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_rarely, 
  ROUND(AVG(b.sometimes) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_sometimes, 
  ROUND(AVG(b.frequently) / (AVG(b.never) + AVG(b.rarely) + AVG(b.sometimes) + AVG(b.frequently)), 2) AS norm_frequently,
  ((SUM(deaths) / SUM(confirmed_cases)) * 100) AS fatality_rate
FROM
  `bigquery-public-data.covid19_nyt.us_counties` AS a
LEFT JOIN
  `bigquery-public-data.covid19_nyt.mask_use_by_county` AS b
ON
  a.county_fips_code = b.county_fips_code
GROUP BY
  a.state_name

