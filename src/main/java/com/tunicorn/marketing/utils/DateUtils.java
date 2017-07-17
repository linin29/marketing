package com.tunicorn.marketing.utils;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
	public static final int YEAR = 9;
	public static final int HYEAR = 8;
	public static final int QUARTER = 7;
	public static final int MONTH = 6;
	public static final int WEEK = 5;
	public static final int DAY = 4;
	public static final int HOUR = 3;
	public static final int MINUTE = 2;
	public static final int SECOND = 1;
	
	private Date date;
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 

	/*
	 * 
	 * 
	 * 对象实例化
	 * 
	 * 
	 */
	public DateUtils(Date date){
		this.date = date;
	}
	
	public DateUtils(Timestamp timeStamp){
        try {  
            this.date = timeStamp;   
        } catch (Exception e) {  
            e.printStackTrace();  
        } 
	}
	
	public DateUtils(String dateStr){
		try {
			this.date = sdf.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	public DateUtils(long milliseconds){
		this.date = new Date(milliseconds);
	}
	
	
	/*
	 * 
	 * 
	 * 日期类型转换相关方法
	 * 
	 * 
	 */
	
	public Date toDate(){
		return this.date;
	}
	
	public Timestamp toTimeStamp(){
		return new Timestamp(this.date.getTime());
	}
	
	public String toDateFormat(){
		return this.sdf.format(this.date);
	}
	
	public String toDateFormat(String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(this.date);
	}
	
	public long toMilliSeconds(){
		return this.date.getTime();
	}
	
	/*
	 * 
	 * 
	 * 获取时间段方法
	 * 
	 * 
	 */
	public long getTimeMillis(){
		return this.date.getTime();
	}
	
	public String getDate(String format){
		return this.toDateFormat(format);
	}
	
	public String getDate(){
		return this.toDateFormat("yyyy-MM-dd");
	}
	
	public String getTime(){
		return this.toDateFormat("HH:mm:ss");
	}
	
	public String getDateTime(){
		return this.toDateFormat();
	}
	
	public long getYear(){
		return this.date.getYear();
	}
	public long getMonth(){
		return this.date.getMonth() + 1;
	}
	public long getDay(){
		return this.date.getDay();
	}
	public long getHours(){
		return this.date.getHours();
	}
	public long getMinutes(){
		return this.date.getMinutes();
	}
	public long getSeconds(){
		return this.date.getSeconds();
	}
	
	/*
	 * 
	 * 
	 * 设置时间段方法
	 * 
	 * 
	 */
	//TODO:
	
	
	/*
	 * 
	 * 
	 * 日期加减运算相关方法
	 * 
	 * 
	 */
	public void add(long type, long num){
		switch(String.valueOf(type)){
			case "1" : 
				this.addYear(num);
				break;
			case "2" : 
				this.addHyear(num);
				break;
			case "3" : 
				this.addQuarter(num);
				break;
			case "4" : 
				this.addMonth(num);
				break;
			case "5" : 
				this.addWeek(num);
				break;
			case "6" : 
				this.addDay(num);
				break;
			case "7" : 
				this.addHours(num);
				break;
			case "8" : 
				this.addMinutes(num);
				break;
			case "9" : 
				this.addSeconds(num);
				break;
		}
	}
	/*
	 * 
	 * GregorianCalendar gc=new GregorianCalendar(); 
	 * gc.setTime(new Date); 
	 * gc.add(field,value);
	 * value为正则往后,为负则往前 
	 * field取1加1年,取2加月,取3加周,取5加一天
	 * gc.set(gc.get(Calendar.YEAR),gc.get(Calendar.MONTH),gc.get(Calendar.DATE));
	 * return sf.format(gc.getTime()); 
	 * 
	 */
	public void addSeconds(long num){
		
	}
	
	public void addMinutes(long num){
		
	}
	
	public void addHours(long num){
		
	}
	
	public void addDay(long num){
		
	}
	
	public void addWeek(long num){
		
	}
	
	public void addMonth(long num){
		
	}
	
	public void addQuarter(long num){
		
	}
	
	public void addHyear(long num){
		
	}
	
	public void addYear(long num){
		
	}
	
	/*
	 * 
	 * 
	 * DateUtils对象运算相关方法
	 * 
	 * 
	 */
	public boolean gt(DateUtils dus){
		return true;
	}
	
	public boolean lt(DateUtils dus){
		return true;
	}
	
	public boolean ge(DateUtils dus){
		return true;
	}
	
	public boolean le(DateUtils dus){
		return true;
	}
	public long sub(DateUtils dus){
		return sub(dus, SECOND);
	}
	public long sub(DateUtils dus, long type){
		switch(String.valueOf(type)){
			case "1" : 
				return this.subInYear(dus);
			case "3" : 
				return this.subInQuarter(dus);
			case "4" : 
				return this.subInMonth(dus);
			case "5" : 
				return this.subInWeek(dus);
			case "6" : 
				return this.subInDay(dus);
			case "7" : 
				return this.subInHours(dus);
			case "8" : 
				return this.subInMinutes(dus);
			case "9" : 
				return this.subInSeconds(dus);
		}
		return 0;
	}

	public long subInYear(DateUtils dus){
		return 0;
	}
	
	public long subInQuarter(DateUtils dus){
		return 0;
	}
	
	public long subInMonth(DateUtils dus){
		return 0;
	}
	
	public long subInWeek(DateUtils dus){
		long days = this.subInDay(dus);
		return days / 7;
	}
	
	public long subInDay(DateUtils dus){
		long hours = this.subInHours(dus);
		return hours / 24;
	}
	
	public long subInHours(DateUtils dus){
		long minutes = this.subInMinutes(dus);
		return minutes / 60;
	}
	
	public long subInMinutes(DateUtils dus){
		long seconds = this.subInSeconds(dus);
		return seconds / 60;
	}
	
	public long subInSeconds(DateUtils dus){
		long timeMillis = this.subInMilliSeconds(dus);
		return timeMillis / 1000;
	}
	
	private long subInMilliSeconds(DateUtils dus){
		return this.getTimeMillis() - dus.getTimeMillis();
	}
	
	/*
	 * 
	 * 
	 * 当前日期时间相关静态方法
	 * 
	 * 
	 */
	public static long getCurrentTimeMillis(){
		return System.currentTimeMillis();
	}
	
	public static String getCurrentDate(){
		long tm = getCurrentTimeMillis();
		DateUtils du = new DateUtils(tm);
		return du.getDate();
	}
	
	public static String getCurrentDate(String format){
		long tm = getCurrentTimeMillis();
		DateUtils du = new DateUtils(tm);
		return du.getDate(format);
	}
	
	public static String getCurrentTime(){
		long tm = getCurrentTimeMillis();
		DateUtils du = new DateUtils(tm);
		return du.getTime();
	}
	
	public static String getCurrentDateTime(){
		long tm = getCurrentTimeMillis();
		DateUtils du = new DateUtils(tm);
		return du.toDateFormat();
	}
	
	public static void main(String[] args){
		DateUtils du = new DateUtils(DateUtils.getCurrentTimeMillis());
		
	}
}
