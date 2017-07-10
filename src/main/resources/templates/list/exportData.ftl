<style type="text/css">
    .captureTable th,.captureTable td{text-align: center;}
    .newline{width:200px; white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
</style>
<div class="exportDataContainer">
    <div class="panel-default" style="margin-bottom:0px">
         <div class="data_list_header" style="margin-left: 2%;">
       	 	<h3>数据导出
            	<small>本次导出共<span id="number">666</span>数据</small>
        	</h3>
    	</div>
        <div class="panel-body">
            <div class="condition row">
            	<div class="form-group col-sm-4">
                     <span class="control-label line-height col-sm-3 text-center" >品类：</span>
                     <div class="col-sm-9">
                         <select style="height: 34px;width: 96%;">
                         	<option value="0">请选择</option>
                         	<option value="1">1</option>
                         	<option value="2">2</option>
                         	<option value="3">3</option>
						</select>               
                     </div>
                 </div>
                 
                 <div class='form-group col-sm-7'>
                 	<span class="control-label line-height col-sm-2 text-center">时间段：</span>
                 	 <div class='col-sm-10'>
                 	 	 <div style="float: left; width: 48%;" class="form-group input-group date form_datetime1" data-date="2016-11-1T05:25:07Z" data-date-format="yyyy-mm-dd hh:ii:ss" >
		                    <input class="form-control" size="16" type="text" value="" id="fromDate">
		                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
		                </div>
		                <div  style="float: left;line-height: 34px" class="form-group glyphicon glyphicon-minus"></div>
		                 <div style="float: left;  width: 48%;" class=" input-group date form_datetime2" data-date="2016-11-1T05:25:07Z" data-date-format="yyyy-mm-dd hh:ii:ss" >
		                    <input class="form-control" size="16" type="text" value="" id="toDate">
		                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
		                </div>
                 	 </div>
                 </div>
                 <div class="text-right" style='margin-right:35px;'>
                     <button class='btn btn-success' id="query">查询</button>
                 </div>
            </div>
            
			<div class="leftTable " style="margin-top: 32px;">
                <table id="track-table" class="table table-hover table-bordered" style="margin-top: 5px">
                    <tbody>
	                    <tr class='tabelCenter' style="background-color: #ccc">
	                    	<th style='width:15%;'>品类名</th>	                
	                    	<th style='width:20%;'>首次出现时间</th>
	                    	<th style='width:20%;'>末次出现时间</th>
	                    	<th style='width:10%;'>操作</th>
	                    </tr>
	                    <tr class='tabelCenter data'>
	                    	<td>21244</td>
	                    	<td>2017-1-1 16:12:01</td>
	                    	<td>2017-2-1 16:12:01</td>
	                    	<td></td>
	                    </tr>
                    </tbody>
                </table>               
                <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;"></div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/dataExport.js"></script>
<script type="text/javascript">
	dataExport._init();
</script>