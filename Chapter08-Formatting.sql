--1)
SELECT c.last, c.first
FROM CRIMINALS c, CRIMES cr
WHERE c.criminal_id = cr.criminal_id
GROUP BY  c.last, c.first
HAVING COUNT(cr.criminal_id) = (SELECT COUNT(crime_id), criminal_id FROM CRIMES GROUP BY criminal_id ORDER BY COUNT(crime_id)DESC);

SELECT c.last, c.first
FROM CRIMINALS c, CRIMES cr
WHERE c.criminal_id = cr.criminal_id
GROUP BY  c.last, c.first
HAVING COUNT(cr.criminal_id) = (SELECT COUNT(crime_id), criminal_id FROM CRIMES GROUP BY criminal_id ORDER BY COUNT(crime_id)DESC);

SELECT cr.last, cr.first
FROM CRIMINALS cr, (SELECT cr.last, cr.first, COUNT(c.crime_id) 
                         FROM crimes c JOIN criminals cr ON c.criminal_id = cr.criminal_id 
                         GROUP BY COUNT(c.crime_id)
                         ORDER BY cr.last, cr.first)
WHERE ROWNUM <= 3;
--2
Set linesize 200
Set pagesize 500
CREATE VIEW CRIMES
AS SELECT cr.criminal_id, cr.last, cr.first, cr.p_status, c.crime_id, c.date_charged, c.status, ch.charge_id, ch.crime_code, ch.charge_status, ch.pay_due_date,
TO_CHAR(((ch.fine_amount + ch.court_fee) - ch.amount_paid),'$9999.99') "Amt Due"
FROM CRIMINALS cr JOIN CRIMES c ON cr.criminal_id = c.criminal_id JOIN CRIME_CHARGES ch ON c.crime_id = ch.crime_id 
WITH READ ONLY;

--3

CREATE MATERIALIZED VIEW Officer_Data
REFRESH COMPLETE
Set linesize 150
Set pagesize 500
Column o.officer_id Format A10
Column o.last Format A8
Column o.first Format A10
Column o.precinct Format A10
Column o.badge Format A8
Column o.status Format A8
START WITH SYSDATE NEXT SYSDATE+14
AS SELECT o.officer_id, o.last, o.first, o.precinct, o.badge, o.phone, o.status, COUNT(cr.crime_id) "Crimes Filed"
FROM OFFICERS o JOIN CRIME_OFFICERS co ON o.officer_id = co.officer_id JOIN CRIMES cr ON co.crime_id = cr.crime_id
GROUP BY o.officer_id, o.last, o.first, o.precinct, o.badge, o.phone, o.status;






