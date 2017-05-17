/*
 1. List the name of each officer who has reported more than the average number of crimes officers
 have reported.
*/
SELECT o.last, o.first
FROM OFFICERS o, CRIMES c, CRIME_OFFICERS co
WHERE o.officer_id = co.officer_id
AND co.crime_id = c.crime_id
GROUP BY o.last, o.first
HAVING COUNT(co.officer_id) > (SELECT COUNT(DISTINCT crime_id) / COUNT(DISTINCT officer_id) FROM CRIME_OFFICERS);
                                      
                               
/*
 2. List the criminal names for all criminals who have a less than average number of crimes and
 aren't listed as violent offenders.
*/
SELECT c.last, c.first
FROM CRIMINALS c, CRIMES cr
WHERE c.criminal_id = cr.criminal_id
AND c.v_status = 'N'
GROUP BY c.last, c1.first
HAVING COUNT(cr.criminal_id) < (SELECT COUNT(DISTINCT crime_id) / COUNT(DISTINCT criminal_id) FROM CRIMES);
                                       
                                  

/*
 3. List appeal information for each appeal that has a less than average number of days
 between the filing and hearing dates.
*/
SELECT a.appeal_id, a.crime_id, a.filing_date, a.hearing_date
FROM APPEALS a
GROUP by a.appeal_id, a.crime_id, a.hearing_date, a.filing_date
HAVING a.hearing_date - a.filing_date < (SELECT AVG(hearing_date - filing_date) FROM appeals);
                                                                                       

/*
 4. List the names of probation officers who have had a less than average number of criminals
 assigned.
*/
SELECT po.last, po.first
FROM PROB_OFFICERS po, SENTENCES s
WHERE po.prob_id = s.prob_id
GROUP by po.last, po.first
HAVING COUNT(s.prob_id) < (SELECT COUNT(DISTINCT sentence_id) / COUNT(DISTINCT prob_id) FROM SENTENCES);
                            

                                  
/*
 5. List each crime that has had the highest number of appeals recorded.
*/
SELECT a.crime_id
FROM APPEALS a, CRIMES c
WHERE a.crime_id = c.crime_id
GROUP BY a.crime_id
HAVING COUNT(a.crime_id) = (SELECT MAX(COUNT(crime_id)) FROM APPEALS GROUP BY crime_id);
                              
                             

/*
 6. List the information on crime charges for each charge that has had a fine above average and
 a sum paid below average.
*/
SELECT cc.charge_id, cc.crime_id
FROM CRIME_CHARGES cc
WHERE cc.fine_amount > (SELECT AVG(fine_amount) FROM crime_charges)
AND cc.amount_paid < (SELECT AVG(amount_paid) FROM crime_charges);

/*
 7. List all the names of all criminals who have had any of the crime code charges involved in
 crime ID 10089.
*/
SELECT DISTINCT c.last, c.first
FROM CRIMINALS c, CRIMES cr, CRIME_CHARGES ch
WHERE c.criminal_id = cr.criminal_id
AND cr.crime_id = ch.crime_id
AND ch.crime_code IN (SELECT crime_code FROM CRIME_CHARGES WHERE crime_id = 10089);
       

/*
 8. Use a correlated subquery to determine which criminals have had at least one probation
 period assigned.
*/
SELECT c.last, c.first
FROM CRIMINALS c
WHERE EXISTS
(SELECT * FROM sentences s WHERE s.criminal_id = c.criminal_id);

/*
 9. List the names of officers who have booked the highest number of crimes. Note that more
 than one officer might be listed.
*/
SELECT o.last, o.first
FROM OFFICERS o, CRIME_OFFICERS co, CRIMES c
WHERE o.officer_id = co.officer_id
AND co.crime_id = c.crime_id
GROUP BY o.last, o.first
HAVING COUNT(co.crime_id) = (SELECT MAX(COUNT(officer_id)) FROM crime_officers GROUP BY officer_id);
                               
                              

/*
 Note: Use a MERGE statement to satisfy the following request:

 10. The criminal data warehouse contains a copy of the CRIMINALS table that needs to be
 updated periodically from the production CRIMINALS table. The data warehouse table is
 named CRIMINALS_DW. Use a single SQL statement to update the data warehouse table
 to reflect any data changes for existing criminals and to add new criminals. 
*/
MERGE INTO criminals_dw cdw
USING (SELECT * FROM CRIMINALS) c
ON (cdw.criminal_id = c.criminal_id)
WHEN MATCHED THEN
  UPDATE
     SET cdw.last     = c.last,
         cdw.first    = c.first,
         cdw.street   = c.street,
         cdw.city     = c.city,
         cdw.state    = c.state,
         cdw.zip      = c.zip,
         cdw.phone    = c.phone,
         cdw.v_status = c.v_status,
         cdw.p_status = c.p_status
WHEN NOT MATCHED THEN
  INSERT
    (cdw.criminal_id, cdw.last, cdw.first, cdw.street, cdw.city, cdw.city, cdw.state, cdw.zip, cdw.phone, cdw.v_status,  cdw.p_status)    
  VALUES (c.criminal_id, c.last, c.first, c.street, c.city, c.state, c.zip, c.phone, c.v_status, c.p_status);
COMMIT;
