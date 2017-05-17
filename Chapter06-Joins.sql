--Part1
--1)Cartesian
SELECT criminal_id, last, first, crime_code, fine_amount
FROM CRIMINALS, CRIME_CHARGES
ORDER BY last, first;

SELECT c.criminal_id, c.last, c.first, cc.crime_code, cc.fine_amount
FROM CRIMINALS c JOIN CRIMES cr ON c.criminal_id = cr.criminal_id
JOIN CRIME_CHARGES cc ON cr.crime_id = cc.crime_id
ORDER BY c.last, c.first;

--2) Outer Join
SELECT c.criminal_id, c.last, c.first, cr.classification, cr.date_charged, a.filing_date, a.status
FROM CRIMINALS c, CRIMES cr, APPEALS a
WHERE c.criminal_id = cr.criminal_id(+)
AND cr.crime_id = a.crime_id(+)
ORDER BY c.last, c.first;

SELECT c.criminal_id, c.last, c.first, cr.classification, cr.date_charged, a.filing_date, a.status
FROM CRIMINALS c 
LEFT OUTER JOIN CRIMES cr ON c.criminal_id = cr.criminal_id
LEFT OUTER JOIN APPEALS a ON cr.crime_id = a.crime_id
ORDER BY c.last, c.first;

--3)Equality Join
SELECT c.criminal_id, c.last, c.first, cr.classification, cr.date_charged, cc.crime_code, ch.fine_amount
FROM CRIMINALS c, CRIMES cr, CRIME_CODES cc, CRIME_CHARGES ch
WHERE c.criminal_id = cr.criminal_id
AND cr.crime_id = ch.crime_id
AND ch.crime_code = cc.crime_code
AND cr.classification = 'O'
ORDER BY c.criminal_id, cr.date_charged;

SELECT c.criminal_id, c.last, c.first, cr.classification, cr.date_charged, cc.crime_code, ch.fine_amount
FROM CRIMINALS c 
JOIN CRIMES cr ON c.criminal_id = cr.criminal_id
JOIN CRIME_CHARGES ch ON cr.crime_id = ch.crime_id
JOIN CRIME_CODES cc ON ch.crime_code = cc.crime_code
WHERE cr.classification = 'O'
ORDER BY c.criminal_id, cr.date_charged;

--4) Outer Join
SELECT c.criminal_id, c.last, c.first, c.v_status, c.p_status, a.alias
FROM CRIMINALS c, ALIASES a
WHERE c.criminal_id = a.criminal_id(+)
ORDER BY c.last, c.first;

SELECT c.criminal_id, c.last, c.first, c.v_status, c.p_status, a.alias
FROM CRIMINALS c LEFT OUTER JOIN ALIASES a
ON c.criminal_id = a.criminal_id
ORDER BY c.last, c.first;

--5) Non Equality Join
SELECT c.last, c.first, s.start_date, s.end_date, p.con_freq
FROM CRIMINALS c, SENTENCES s, PROB_CONTACT p
WHERE c.criminal_id = s.criminal_id
AND s.end_date - s.start_date BETWEEN p.low_amt and p.high_amt
ORDER BY c.last, s.start_date;

SELECT c.last, c.first, s.start_date, s.end_date, p.con_freq
FROM CRIMINALS c JOIN SENTENCES s ON c.criminal_id = s.criminal_id
JOIN PROB_CONTACT ON s.end_date - s.start_date BETWEEN p.low_amt and p.high_amt
ORDER BY c.last, s.start_date;

--6)
SELECT o.last, o.first, m.last "Manager"
FROM PROB_OFFICERS o, PROB_OFFICERS m
WHERE o.mgr_ID = m.prob_id
ORDER BY o.last, o.first;


--Part II
--1)
SELECT crime_id, classification, date_charged, hearing_date, ABS(date_charged - hearing_date) "num_days"
FROM CRIMES
WHERE ABS(date_charged - hearing_date) > '14';

--2)
Set linesize 115
Set pagesize 500
Column last Format A9
Column first Format A6
SELECT last, first, 
CASE
 WHEN(SUBSTR(precinct, 2, 1)='A') THEN 'Shady Grove'
 WHEN(SUBSTR(precinct, 2, 1)='B') THEN 'City Center'
 WHEN(SUBSTR(precinct, 2, 1)='C') THEN 'Bay Landing'
 ELSE 'Unassigned'
END"Community Assign"
FROM OFFICERS
WHERE STATUS = 'A';

--3)
Set linesize 115
Set pagesize 500
Column c.last Format A9
Column c.first Format A6
Column date Format A18
Column s.sentence Format A10
SELECT c.criminal_id, UPPER(c.last) "Last", UPPER(c.first) "First", s.sentence_id, 
TO_CHAR(s.start_date, 'MONTH DD, YYYY') "DATE",
ABS(ROUND(MONTHS_BETWEEN(s.start_date, s.end_date))) "Length"
FROM CRIMINALS c, SENTENCES s
WHERE c.criminal_id = s.criminal_id;

--4)
Set linesize 150
Set pagesize 500
SELECT c.last, c.first, ch.charge_id, 
TO_CHAR((ch.fine_amount + ch.court_fee),'$9999.99') "Amt_Owed", 
TO_CHAR(NULLIF(ch.amount_paid, (ch.fine_amount + ch.court_fee)),'$9999.99') "AMT_Paid",
TO_CHAR(((ch.fine_amount + ch.court_fee) - ch.amount_paid), '$9999.99') "Total_Owed",
ch.pay_due_date
FROM CRIMINALS c JOIN CRIMES cr ON c.criminal_id = cr.criminal_id
JOIN CRIME_CHARGES ch ON cr.crime_id = ch.crime_id
WHERE ((ch.fine_amount + ch.court_fee) - ch.amount_paid) > 0 OR ch.amount_paid IS NULL
ORDER BY c.last, c.first;

--5)
SELECT c.last, c.first, s.start_date
FROM CRIMINALS c JOIN SENTENCES s ON c.criminal_id = s.criminal_id
WHERE s.type = 'P'
ORDER BY c.last, c.first;

--6)

INSERT INTO CRIMES (appeal_id, crime_id, filing_date, hearing_date, status)
VALUES (DEFAULT,'&CID', TO_DATE('&Filing_Date','MM DD YYYY'), TO_DATE('&Hearing_Date', 'MM DD YYYY'), DEFAULT);












