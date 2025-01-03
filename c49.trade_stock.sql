--Day49: write sql to find all couples of trade for same stock that happened in the range of 10 seconds and having price difference  by more than 10%.
-- Output result should also list the perecentage of price differnce between the 2 trade.

Create Table Trade_tbl( TRADE_ID varchar(20), Trade_Timestamp time, Trade_Stock varchar(20), Quantity int, Price Float ) 
Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20) 
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15) 
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30) 
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32) 
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19) 
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19)
Insert into Trade_tbl Values('TRADE1','10:10:00','Infosys',-100,19) 
Insert into Trade_tbl Values('TRADE2','10:10:01','Infosys',-300,19)
Insert into Trade_tbl Values('TRADE3','10:01:05','Infosys',100,20) 
Insert into Trade_tbl Values('TRADE4','10:01:06','Infosys',20,15) 

select * from Trade_tbl;

select *
,abs(a.price-b.price)*1.0/a.price * 100 as price_diff_percentage
from Trade_tbl a 
join Trade_tbl b on a.Trade_Stock=b.Trade_Stock
where a.TRADE_ID!=b.TRADE_ID
and a.Trade_Timestamp < b.Trade_Timestamp --as we hv (Trade1,Trade2) combination and (Trade2,Trade1) don't come
and datediff(second,a.Trade_Timestamp,b.Trade_Timestamp)<10
and abs(a.price-b.price)*1.0/a.price * 100 > 10
order by a.TRADE_ID
