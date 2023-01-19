
- Топ 5 найпопулярніших статей (ті що мають найбільшу кількість посилань на себе)
with first as(select l.id, l.title
				from link as l
				where l.title in (select p.title
								  	from page as p))

select s.counter as coun_of_links,
       l.title
	from
	(select a.link as l_id,
	        a.counter as counter
		  	from
	 			(
	 			select count(ptl.link) as counter,
	 			        ptl.link as link
			  			from page_to_link as ptl
						join first as f on f.id = ptl.link
						group by ptl.link
						order by counter DESC) as a
						) as s
join link as l
    on l.id = s.l_id
order by coun_of_links desc




- Топ 5 статей з найбільшою кількістю посилань на інші статті
select p.title, count(p.title)
from page as p
JOIN page_to_link as ptl
	ON p.id = ptl.page
JOIN link as l
	ON ptl.link = l.id
group by p.title
order by count(p.title) DESC
limit 5




- Для заданної статті знайти середню кількість потомків другого рівня
--1)для дружбы находим список уникальных дочерних ссылок и обзываем first
 with first as (select distinct(l.title) as title
			      from page as p
			      join page_to_link as ptl
			        on ptl.page = p.id
				  join link as l
				    on l.id = ptl.link
			      where p.title = 'Дружба')
--3) считаем средние переходы
 select avg(a.counter) from
 --2)для полученого списка дочерних ссылок считаем количество переходов
( select  count(ptl.link) as counter
 from page as p
 join page_to_link as ptl
    on ptl.page = p.id
 join first as f
    on f.title = p.title
 group by f.title) a