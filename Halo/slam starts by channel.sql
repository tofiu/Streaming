select source_cd,
       sum(start_cnt) as starts
FROM ent_vw.subscription_slam_summary_day
where day_dt between "2022-04-24" and "2022-04-24"
and slam_show_gp_nm = 'Halo'
group by 1
order by 1
