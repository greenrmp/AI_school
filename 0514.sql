drop table if exists `icifinal_di_temp.z_usd_page`;

create table `icifinal_di_temp.z_usd_page` as
select
    A.sessionnumber,
    A.pagelocation,
    A.pagetitle,
    A.pageinstanceid,
    A.eventtimestamp,
    A.date,
    B.pageviewactivetime,
    case when A.pagelocation like 'https://www.o-bank.com/web/Event/CM_1070701/index.html' then 'cam_page'
        when A.pagelocation like '%/retail/cm/ratemain' then 'rate_main'
        when A.pagelocation like '%/retail/cm/ratemain/cm-foredeprate' then 'FIR_page' --外利率頁
        when A.pagelocation like '%/retail/cm/ratemain/cm-deprate' then 'TWIR_page' --台利率頁
        when A.pagelocation like '%/retail/cm/ratemain/cm-fxrate%' then 'fxrate_page' --匯率頁
        when A.pagelocation like '%FFX03001%' then 'ibmb_fx_trade'  --買賣外匯
        when A.pagelocation like '%FFX02001%' then 'ibmb_setprice'  --匯率到價通知
        when A.pagelocation like '%FCO08001%' then 'ibmb_rate_all'  --即時利匯率查詢
        when A.pagelocation like '%FCO08007%' then 'ibmb_rate_fx'   --即時匯率查詢
        when A.pagelocation like '%FFX01001%' then 'ibmb_fx_trend'  --匯率走勢圖
        else 'others'end as page_flag       
from icifinal.page A
LEFT JOIN icifinal.pagesummary B
ON A.sessionnumber=B.sessionnumber AND A.pageinstanceid=B.pageinstanceid
where A.date>='2018-02-19' and A.date<='2018-04-30'

drop table if exists `icifinal_di_temp.z_idusdpage`;

create table `icifinal_di_temp.z_idusdpage` as
select distinct
    idsess.profileid,
    idsess.cookieuniquevisitortrackingid,
    idsess.sessionnumber,
    idsess.date,
    usdpage.pagetitle,
    usdpage.pageinstanceid,
    usdpage.eventtimestamp,
    usdpage.pageviewactivetime,
    usdpage.page_flag
from 
(select distinct profileid, cookieuniquevisitortrackingid, sessionnumber, date
from icifinal_di_dev.customersessioncookie_total
where date>='2018-02-19' and date<='2018-04-30' ) idsess
left join z_usd_page as usdpage
on idsess.sessionnumber = usdpage.sessionnumber


drop table if exists `icifinal_di_temp.z_usd_behavior`;

create table z_usd_behavior as
select *, 
    case when datediff(a.first_date_n, date)<=6 and datediff(a.first_date_n, date)>=0 then 'pre7'
        when datediff(a.first_date_n, date)<=13 and datediff(a.first_date_n, date)>=7 then 'pre14'
        when datediff(a.first_date_n, date)<=20 and datediff(a.first_date_n, date)>=14 then 'pre21' 
        when datediff(a.first_date_n, date)<=27 and datediff(a.first_date_n, date)>=21 then 'pre28'
        else 'outofrange' end as date_note
from pdh_usd430 A
left JOIN z_idusdpage B
on A.user_pk = B.profileid
where B.profileid is not null




drop table if exists `icifinal_di_temp.digitaltag_usd`;

create table digitaltag_usd as
select cif_no, opn_dt, usd_yn,
    count(distinct case when date_note ='pre14' then date else null end) as cnt_date_pre14,
    count(distinct case when date_note ='pre14-30' then date else null end) as cnt_date_pre1430,
    count(distinct case when date_note ='post14' then date else null end) as cnt_date_post14,
    count(distinct case when date_note ='pre14' then cookieuniquevisitortrackingid else null end) as cnt_cookie_pre14,
    count(distinct case when date_note ='pre14-30' then cookieuniquevisitortrackingid else null end) as cnt_cookie_pre1430,
    count(distinct case when date_note ='post14' then cookieuniquevisitortrackingid else null end) as cnt_cookie_post14,
    count(distinct case when date_note ='pre14' then sessionnumber else null end) as cnt_sess_pre14,
    count(distinct case when date_note ='pre14-30' then sessionnumber else null end) as cnt_sess_pre1430,
    count(distinct case when date_note ='post14' then sessionnumber else null end) as cnt_sess_post14,
    sum(case when date_note ='pre14' then pageviewactivetime else null end) as viewtime_pre14,
    sum(case when date_note ='pre14-30' then pageviewactivetime else null end) as viewtime_pre1430,
    sum(case when date_note ='post14' then pageviewactivetime else null end) as viewtime_post14,
    sum(case when date_note ='pre14' and page_flag='cam_page' then 1 else 0 end) as cnt_campage_pre14,
    sum(case when date_note ='pre14-30' and page_flag='cam_page' then 1 else 0 end) as cnt_campage_pre1430,
    sum(case when date_note ='post14' and page_flag='cam_page' then 1 else 0 end) as cnt_campage_post14,
    sum(case when date_note ='pre14' and page_flag='rate_main' then 1 else 0 end) as cnt_ratemain_pre14,
    sum(case when date_note ='pre14-30' and page_flag='rate_main' then 1 else 0 end) as cnt_ratemain_pre1430,
    sum(case when date_note ='post14' and page_flag='rate_main' then 1 else 0 end) as cnt_ratemain_post14,
    sum(case when date_note ='pre14' and page_flag='FIR_page' then 1 else 0 end) as cnt_FIRpage_pre14,
    sum(case when date_note ='pre14-30' and page_flag='FIR_page' then 1 else 0 end) as cnt_FIRpage_pre1430,
    sum(case when date_note ='post14' and page_flag='FIR_page' then 1 else 0 end) as cnt_FIRpage_post14,
    sum(case when date_note ='pre14' and page_flag='TWIR_page' then 1 else 0 end) as cnt_TWIRpage_pre14,
    sum(case when date_note ='pre14-30' and page_flag='TWIR_page' then 1 else 0 end) as cnt_TWIRpage_pre1430,
    sum(case when date_note ='post14' and page_flag='TWIR_page' then 1 else 0 end) as cnt_TWIRpage_post14,
    sum(case when date_note ='pre14' and page_flag='fxrate_page' then 1 else 0 end) as cnt_fxrate_page_pre14,
    sum(case when date_note ='pre14-30' and page_flag='fxrate_page' then 1 else 0 end) as cnt_fxrate_page_pre1430,
    sum(case when date_note ='post14' and page_flag='fxrate_page' then 1 else 0 end) as cnt_fxrate_page_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_fx_trade' then 1 else 0 end) as cnt_ibmb_fx_trade_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_fx_trade' then 1 else 0 end) as cnt_ibmb_fx_trade_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_fx_trade' then 1 else 0 end) as cnt_ibmb_fx_trade_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_setprice' then 1 else 0 end) as cnt_ibmb_setprice_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_setprice' then 1 else 0 end) as cnt_ibmb_setprice_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_setprice' then 1 else 0 end) as cnt_ibmb_setprice_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_rate_all' then 1 else 0 end) as cnt_ibmb_rate_all_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_rate_all' then 1 else 0 end) as cnt_ibmb_rate_all_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_rate_all' then 1 else 0 end) as cnt_ibmb_rate_all_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_rate_fx' then 1 else 0 end) as cnt_ibmb_rate_fx_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_rate_fx' then 1 else 0 end) as cnt_ibmb_rate_fx_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_rate_fx' then 1 else 0 end) as cnt_ibmb_rate_fx_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_fx_trend' then 1 else 0 end) as cnt_ibmb_fx_trend_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_fx_trend' then 1 else 0 end) as cnt_ibmb_fx_trend_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_fx_trend' then 1 else 0 end) as cnt_ibmb_fx_trend_post14
from z_usd_behavior
group by cif_no, opn_dt, usd_yn





































drop table if exists `icifinal_di_temp.z_usd_behavior`;
create table z_usd_behavior as
select *, 
    case when datediff(a.first_date_n, date)<=14 and datediff(a.first_date_n, date)>=0 then 'pre14' 
        when datediff(a.first_date_n, date)>14 and datediff(a.first_date_n, date)<=30 then 'pre14-30'
        when datediff(a.first_date_n, date)<0 and datediff(a.first_date_n, date)>=-14 then 'post14'
        else 'outofrange' end as date_note
from pdh_usd430 A
left JOIN z_idusdpage B
on A.user_pk = B.profileid
where B.profileid is not null


drop table if exists `icifinal_di_temp.idusdpage`;

create table `icifinal_di_temp.z_idusdpage` as
select distinct
    idsess.profileid,
    idsess.cookieuniquevisitortrackingid,
    idsess.sessionnumber,
    idsess.date,
    usdpage.pagetitle,
    usdpage.pageinstanceid,
    usdpage.eventtimestamp,
    usdpage.pageviewactivetime,
    usdpage.page_flag
from 
(select distinct profileid, cookieuniquevisitortrackingid, sessionnumber, date
from icifinal_di_dev.customersessioncookie_total
where date>='2018-02-19' and date<='2018-04-30' ) idsess
left join z_usd_page as usdpage
on idsess.sessionnumber = usdpage.sessionnumber


drop table if exists `icifinal_di_temp.z_usd_page`;

create table `icifinal_di_temp.z_usd_page` as
select
    A.sessionnumber,
    A.pagelocation,
    A.pagetitle,
    A.pageinstanceid,
    A.eventtimestamp,
    A.date,
    B.pageviewactivetime,
    case when A.pagelocation like 'https://www.o-bank.com/web/Event/CM_1070701/index.html' then 'cam_page'
        when A.pagelocation like '%/retail/cm/ratemain' then 'rate_main'
        when A.pagelocation like '%/retail/cm/ratemain/cm-foredeprate' then 'FIR_page' --外利率頁
        when A.pagelocation like '%/retail/cm/ratemain/cm-deprate' then 'TWIR_page' --台利率頁
        when A.pagelocation like '%/retail/cm/ratemain/cm-fxrate%' then 'fxrate_page' --匯率頁
        when A.pagelocation like '%FFX03001%' then 'ibmb_fx_trade'  --買賣外匯
        when A.pagelocation like '%FFX02001%' then 'ibmb_setprice'  --匯率到價通知
        when A.pagelocation like '%FCO08001%' then 'ibmb_rate_all'  --即時利匯率查詢
        when A.pagelocation like '%FCO08007%' then 'ibmb_rate_fx'   --即時匯率查詢
        when A.pagelocation like '%FFX01001%' then 'ibmb_fx_trend'  --匯率走勢圖
        else 'what'end as page_flag       
from icifinal.page A
LEFT JOIN icifinal.pagesummary B
ON A.sessionnumber=B.sessionnumber AND A.pageinstanceid=B.pageinstanceid
where A.date>='2018-02-19' and A.date<='2018-04-30' 
    and (A.pagelocation like 'https://www.o-bank.com/web/Event/CM_1070701/index.html' 
    or A.pagelocation like 'https://www.o-bank.com/retail/cm/ratemain%'
    or A.pagelocation like '%FFX01001%'
    or A.pagelocation like '%FFX02001%'
    or A.pagelocation like '%FFX03001%'
    or A.pagelocation like '%FCO08007%'
    or A.pagelocation like '%FCO08001%')
    

select *
from z_usd_behavior
where page_flag is not null

create table icifinal_di_temp.digitaltag_usd as
select cif_no, opn_dt, usd_yn,
    count(distinct case when date_note ='pre14' then date else null end) as cnt_date_pre14,
    count(distinct case when date_note ='pre14-30' then date else null end) as cnt_date_pre1430,
    count(distinct case when date_note ='post14' then date else null end) as cnt_date_post14,
    count(distinct case when date_note ='pre14' then cookieuniquevisitortrackingid else null end) as cnt_cookie_pre14,
    count(distinct case when date_note ='pre14-30' then cookieuniquevisitortrackingid else null end) as cnt_cookie_pre1430,
    count(distinct case when date_note ='post14' then cookieuniquevisitortrackingid else null end) as cnt_cookie_post14,
    count(distinct case when date_note ='pre14' then sessionnumber else null end) as cnt_sess_pre14,
    count(distinct case when date_note ='pre14-30' then sessionnumber else null end) as cnt_sess_pre1430,
    count(distinct case when date_note ='post14' then sessionnumber else null end) as cnt_sess_post14,
    sum(case when date_note ='pre14' then pageviewactivetime else null end) as viewtime_pre14,
    sum(case when date_note ='pre14-30' then pageviewactivetime else null end) as viewtime_pre1430,
    sum(case when date_note ='post14' then pageviewactivetime else null end) as viewtime_post14,
    sum(case when date_note ='pre14' and page_flag='cam_page' then 1 else 0 end) as cnt_campage_pre14,
    sum(case when date_note ='pre14-30' and page_flag='cam_page' then 1 else 0 end) as cnt_campage_pre1430,
    sum(case when date_note ='post14' and page_flag='cam_page' then 1 else 0 end) as cnt_campage_post14,
    sum(case when date_note ='pre14' and page_flag='rate_main' then 1 else 0 end) as cnt_ratemain_pre14,
    sum(case when date_note ='pre14-30' and page_flag='rate_main' then 1 else 0 end) as cnt_ratemain_pre1430,
    sum(case when date_note ='post14' and page_flag='rate_main' then 1 else 0 end) as cnt_ratemain_post14,
    sum(case when date_note ='pre14' and page_flag='FIR_page' then 1 else 0 end) as cnt_FIRpage_pre14,
    sum(case when date_note ='pre14-30' and page_flag='FIR_page' then 1 else 0 end) as cnt_FIRpage_pre1430,
    sum(case when date_note ='post14' and page_flag='FIR_page' then 1 else 0 end) as cnt_FIRpage_post14,
    sum(case when date_note ='pre14' and page_flag='TWIR_page' then 1 else 0 end) as cnt_TWIRpage_pre14,
    sum(case when date_note ='pre14-30' and page_flag='TWIR_page' then 1 else 0 end) as cnt_TWIRpage_pre1430,
    sum(case when date_note ='post14' and page_flag='TWIR_page' then 1 else 0 end) as cnt_TWIRpage_post14,
    sum(case when date_note ='pre14' and page_flag='fxrate_page' then 1 else 0 end) as cnt_fxrate_page_pre14,
    sum(case when date_note ='pre14-30' and page_flag='fxrate_page' then 1 else 0 end) as cnt_fxrate_page_pre1430,
    sum(case when date_note ='post14' and page_flag='fxrate_page' then 1 else 0 end) as cnt_fxrate_page_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_fx_trade' then 1 else 0 end) as cnt_ibmb_fx_trade_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_fx_trade' then 1 else 0 end) as cnt_ibmb_fx_trade_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_fx_trade' then 1 else 0 end) as cnt_ibmb_fx_trade_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_setprice' then 1 else 0 end) as cnt_ibmb_setprice_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_setprice' then 1 else 0 end) as cnt_ibmb_setprice_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_setprice' then 1 else 0 end) as cnt_ibmb_setprice_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_rate_all' then 1 else 0 end) as cnt_ibmb_rate_all_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_rate_all' then 1 else 0 end) as cnt_ibmb_rate_all_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_rate_all' then 1 else 0 end) as cnt_ibmb_rate_all_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_rate_fx' then 1 else 0 end) as cnt_ibmb_rate_fx_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_rate_fx' then 1 else 0 end) as cnt_ibmb_rate_fx_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_rate_fx' then 1 else 0 end) as cnt_ibmb_rate_fx_post14,
    sum(case when date_note ='pre14' and page_flag='ibmb_fx_trend' then 1 else 0 end) as cnt_ibmb_fx_trend_pre14,
    sum(case when date_note ='pre14-30' and page_flag='ibmb_fx_trend' then 1 else 0 end) as cnt_ibmb_fx_trend_pre1430,
    sum(case when date_note ='post14' and page_flag='ibmb_fx_trend' then 1 else 0 end) as cnt_ibmb_fx_trend_post14
from icifinal_di_temp.z_usd_behavior
group by cif_no, opn_dt, usd_yn

































select distinct
    
    page_base.sessionnumber,
    page_base.pagelocation,
    visior_base.cookieuniquevisitortrackingid,
    upper(individual_base.profileuiid)


from (
    select 
        sessionnumber,
        pagelocation
    from icifinal.page
    where instr(pagelocation, 'utm_source=sms') > 0 
    and date >= '2017-11-01'    
    group by sessionnumber, pagelocation
    ) page_base

left join (
    select 
        sessionnumber,
        cookieuniquevisitortrackingid
    from icifinal.visitor
    where date >= '2017-11-01'
    group by sessionnumber, cookieuniquevisitortrackingid
    ) visior_base
on (page_base.sessionnumber=visior_base.sessionnumber)

left join (
    select
    cookieuniquevisitortrackingid,
    profileuiid
    from icifinal.individual
    where profileuiid is not null
    group by cookieuniquevisitortrackingid, profileuiid
    ) individual_base
on (visior_base.cookieuniquevisitortrackingid=individual_base.cookieuniquevisitortrackingid)

left join (select cookieuniquevisitortrackingid from icifinal_di.obankipcookieandspyder) exclude 
on (exclude.cookieuniquevisitortrackingid=individual_base.cookieuniquevisitortrackingid)

where exclude.cookieuniquevisitortrackingid is null
and individual_base.profileuiid is not null
;






















drop table if exists `icifinal_di_temp.testusd`;


drop table if exists `icifinal_di_temp.usdpage_t`;
create table `icifinal_di_temp.usdpage_t` as
select
    A.sessionnumber,
    A.pagelocation,
    A.pagetitle,
    A.pageinstanceid,
    A.eventtimestamp,
    A.date,
    B.pageviewactivetime              
from icifinal.page A
LEFT JOIN icifinal.pagesummary B
ON A.sessionnumber=B.sessionnumber AND A.pageinstanceid=B.pageinstanceid
where A.date>='2017-04-30' and A.date<='2018-04-30' 
    and A.pagelocation like 'https://www.o-bank.com/web/Event/CM_1070701/index.html' 

create table usd_behavior as
select *
from pdh_usd430 A
left JOIN idusdpage B
on A.user_pk = B.profileid

drop table if exists `icifinal_di_temp.idusdpage`;

create table `icifinal_di_temp.z_idusdpage` as
select distinct
    idsess.profileid,
    idsess.cookieuniquevisitortrackingid,
    z_usd_page.*
from 
    (
        
select *
from
(select distinct profileid, cookieuniquevisitortrackingid, sessionnumber
from icifinal_di_dev.customersessioncookie_total) idsess
left join z_usd_page as usdpage
on idsess.sessionnumber = usdpage.sessionnumber


drop table if exists `icifinal_di_temp.z_usd_page`;

create table `icifinal_di_temp.z_usd_page` as
select
    A.sessionnumber,
    A.pagelocation,
    A.pagetitle,
    A.pageinstanceid,
    A.eventtimestamp,
    A.date,
    B.pageviewactivetime,
    case when A.pagelocation like 'https://www.o-bank.com/web/Event/CM_1070701/index.html' then 'cam_page'
        when A.pagelocation like '%/retail/cm/ratemain' then 'rate_main'
        when A.pagelocation like '%/retail/cm/ratemain/cm-foredeprate' then 'FIR_page' --外利率頁
        when A.pagelocation like '%/retail/cm/ratemain/cm-deprate' then 'TWIR_page' --台利率頁
        when A.pagelocation like '%/retail/cm/ratemain/cm-fxrate%' then 'fxrate_page' --匯率頁
        when A.pagelocation like '%FFX03001%' then 'ibmb_fx_trade'  --買賣外匯
        when A.pagelocation like '%FFX02001%' then 'ibmb_setprice'  --匯率到價通知
        when A.pagelocation like '%FCO08001%' then 'ibmb_rate_all'  --即時利匯率查詢
        when A.pagelocation like '%FCO08007%' then 'ibmb_rate_fx'   --即時匯率查詢
        when A.pagelocation like '%FFX01001%' then 'ibmb_fx_trend'  --匯率走勢圖
        else 'what'end as page_flag       
from icifinal.page A
LEFT JOIN icifinal.pagesummary B
ON A.sessionnumber=B.sessionnumber AND A.pageinstanceid=B.pageinstanceid
where A.date>='2018-02-19' and A.date<='2018-04-30' 
    and (A.pagelocation like 'https://www.o-bank.com/web/Event/CM_1070701/index.html' 
    or A.pagelocation like 'https://www.o-bank.com/retail/cm/ratemain%'
    or A.pagelocation like '%FFX01001%'
    or A.pagelocation like '%FFX02001%'
    or A.pagelocation like '%FFX03001%'
    or A.pagelocation like '%FCO08007%'
    or A.pagelocation like '%FCO08001%')