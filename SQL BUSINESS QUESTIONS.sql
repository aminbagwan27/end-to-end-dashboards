Q1) WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?

select * from employee
order by levels desc
limit 1

Q2) WHICH COUNTRIES HAVE THE MOST INVOICES?

select count(*)as c,billing_country
from invoice
group by billing_country
order by c desc

Q3) WHICH ARE TOP 3 VALUES OF TOTAL INVOICES?

select total from invoice
order by total desc
limit 3

Q4) WHICH CITY HAS THE BEST CUSTOMERS? WRITE A QUERY THAT RETURNS ONE CITY THAT HAS THE HIGHEST SUM OF INVOICES TOTAL RETURN BOTH
THE CITY NAME & SUM OF ALL THE INVOICE

select sum(total)as invoice_total,billing_city 
from invoice 
group by billing_city
order by invoice_total desc

Q5) WHO IS THE BEST CUSTOMER? WRITE A QUERY THATS RETURNS THE PERSON WHO HAS SPENT THE MOST MONEY

SELECT customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

Q6) WRITE QUERY TO RETURN THE EMAIL,FIRST NAME , LAST NAME & GENRE OF ALL ROCK MUSIC LISTNERS
RETURN YOUR LIST IN ALPHABETICALLY BY EMAIL STARTING WITH A


SELECT DISTINCT email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
)
order by email;

Q7) WRITE A QUERY THAT RETURNS THE ARTIST NAME AND TOTAL TRACK COUNT
OF THE TOP 10 ROCK BANDS

SELECT artist.artist_id , artist.name ,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10 ;

Q8)RETURN THE NAME AND MILLISECONDS FOR EACH TRACK ORDER BY THE SONG LENGTH WITH THE LONGEST SONGS LISTED FIRST

SELECT name,milliseconds
from track
where milliseconds > (
select avg(milliseconds) as avg_track_length
from track)
order by milliseconds desc;

Q9) FIND HOW MUCH AMOUNT SPENT BY EACH CUSTOMER ON ARTISTS?
RETURN CUSTOMER NAME,ARTIST NAME AND TOTAL SPENT

with  best_selling_artist as(
select artist.artist_id as artist_id ,artist.name as artist_name, 
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales 
from invoice_line 
join track on track.track_id = invoice_line. track_id 
join album on album.album_id = track . album_id 
join artist on artist.artist_id = album.artist_id 
group by 1 
order by 3 desc 
limit 1  
)

select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spend 
from invoice i 
join customer c on c.customer_id = i.customer_id 
join invoice_line il on il.invoice_id = i.invoice_id 
join track t on t.track_id = il.track_id 
join album alb on alb.album_id = t.album_id 
join best_selling_artist bsa on bsa.artist_id = alb. artist_id 
group by 1,2,3,4 
order by 5 desc; 

Q10) FIND OUT THE MOST POPULAR GENRE FROM EACH COUNTRY WRITE A QUERY THAT RETURNS EACH COUNTRY 
ALONG WITH THE TOP GENRE.FOR COUNTRIES WHERE MAXIMUM NUMBER OF PURCHASES IS SHARED RETURN ALL GENRES

with popular_genre as
(
 select count (invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id, 
row_number() over(partition by customer.country order by count (invoice_line.quantity) desc) as rowno 
from invoice_line 
join invoice on invoice.invoice_id =invoice_line.invoice_id 
join customer on customer.customer_id = invoice.customer_id 
join track on track.track_id = invoice_line.track_id 
 join genre on genre .genre_id = track .genre_id 
group by 2,3,4
order by 2 asc , 1 desc
 )
 select * from popular_genre where rowno  <=1











