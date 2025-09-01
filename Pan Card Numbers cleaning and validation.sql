create table pan_data (
pan_numbers varchar(20)
);
select * from pan_data;

--data cleaning steps
--checking missing\null values
select * from pan_data
where pan_numbers is null;

--checking duplicates
select pan_numbers, count(*) as count_of_appearance from pan_data
group by pan_numbers
having count(*)>1;

--handling leading\trailing spaces
select pan_numbers
from pan_data
where pan_numbers != trim(pan_numbers);

--pan numbers not in correct case
select pan_numbers
from pan_data
where pan_numbers != upper(pan_numbers);

--cleaned pan numbers
select distinct(trim(upper(pan_numbers))) as clean_pan_numbers
from pan_data
where pan_numbers is not null and trim(pan_numbers)!= '';

--function to check if adjacent characters are same - AKMAL5214l
CREATE OR REPLACE FUNCTION check_adjacent_characters(pan_numbers VARCHAR(20))
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1 .. length(pan_numbers) - 1 LOOP
        IF substring(pan_numbers, i, 1) = substring(pan_numbers, i + 1, 1) THEN
            RETURN TRUE;  -- found identical adjacent characters
        END IF;
    END LOOP;
    RETURN FALSE; -- no adjacent characters are identical
END;
$$;
select check_adjacent_characters('NFAPS4116F')

--Function to check if sequential characters are used
CREATE OR REPLACE FUNCTION check_sequential_characters(pan_numbers VARCHAR(20))
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1 .. length(pan_numbers) - 1 LOOP
        IF ascii(substring(pan_numbers, i+1, 1)) - ascii(substring(pan_numbers, i, 1)) !=1
		THEN
            RETURN false;  -- not found sequential characters
        END IF;
    END LOOP;
    RETURN FALSE; -- found sequential characters
END;
$$;
select check_sequential_characters('abhi')

--Regular Expression to validate the pattern and structure of Pan Numbers
select * 
from pan_data
where pan_numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]$';

--valid and invalid pan categorization
create or replace view vw_valid_invalid as
with cte_cleaned_pan as
(select distinct(trim(upper(pan_numbers))) as clean_pan_numbers
from pan_data
where pan_numbers is not null and trim(pan_numbers)!= ''),

cte_valid_pans as 
(select * from cte_cleaned_pan
where check_adjacent_characters(clean_pan_numbers)=false and
check_sequential_characters(substring(clean_pan_numbers,1,5))=false and 
check_sequential_characters(substring(clean_pan_numbers,6,4)) = false and
clean_pan_numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]$')

select cln.clean_pan_numbers,
case when vld.clean_pan_numbers is not null then 'Valid Pan' else 'Invalid Pan'
end as status
from cte_cleaned_pan cln
left join cte_valid_pans vld on vld.clean_pan_numbers =cln.clean_pan_numbers;

select * from vw_valid_invalid;

--Report
with cte as 
(select (select count(*) as total_processed_record from pan_data) ,count(*) filter(where status = 'Valid Pan') as total_valid_pans,
count(*) filter(where status = 'Invalid Pan') as total_invalid_pans
from vw_valid_invalid)
select total_processed_record,total_valid_pans,total_invalid_pans,total_processed_record-(total_valid_pans+total_invalid_pans) as total_null_records
from cte