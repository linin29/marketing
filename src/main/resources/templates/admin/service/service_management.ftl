<style type='text/css'>
	.tdCenter td,.thCenter th{
		text-align:center;
	}
	.total{
		width:100%;
	}
	.newline{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
	.select-style{
		width: 343px;
    	height: 34px;
	}
	.money-style{
		border: none;
	    outline: none;
	    width: 70px;
	}
</style>
<div class="panel-default clearBottom">
  			<div class="panel-heading">服务管理</div>
  			<div class="panel-body">
    			<div id="request-header" class="row" style='margin-left:-14px;'>
					<div class="col-sm-2">
  						<input id="projectId" <#if projectId??> value="${projectId}"</#if> type="text" class="form-control" placeholder="请输入项目编码">
					</div>
					<div class="col-sm-2">
  						<input id="projectName" <#if projectName??> value="${projectName}"</#if> type="text" class="form-control" placeholder="请输入项目名称">
					</div>
					<div class="col-sm-2">
  						<select id="projectTypeSearch"  style="height: 34px;width:100%">
  							<option value="">请选择项目类型</option>
					      	<option value='free' <#if projectType?? && projectType=='free'>selected</#if>>免费测试</option>
					      	<option value='paid' <#if projectType?? && projectType=='paid'>selected</#if>>付费测试</option>
					      	<option value='official' <#if projectType?? && projectType=='official'>selected</#if>>正式合同</option>
  						</select> 
					</div>
					<div class="col-sm-2">
					<input id="initApplyStatus" type="hidden" <#if applyStatus??> value="${applyStatus}"</#if>>
  						<select id="applyStatus" style="width:70%;height: 34px;">
  							<option value="">请选择状态</option>
  							<option value="created" <#if applyStatus?? && applyStatus=='created'>selected</#if>>已创建</option>
  							<option value="opened" <#if applyStatus?? && applyStatus=='opened'>selected</#if>>已开通</option>
  							<option value="rejected" <#if applyStatus?? && applyStatus=='rejected'>selected</#if>>已驳回</option>
  							<option value="closed" <#if applyStatus?? && applyStatus=='closed'>selected</#if>>已关闭</option>
  						</select>
					</div> 
					<div class="pull-right col-sm-4" style="padding-right: 0px;">
						<div class="col-sm-3">
  						   <input id="query" type="button" class=" btn btn-success" value="搜索" style="width:100px;" />
					   </div>
					</div>

				</div>
  			    <div id="request-content">
  			    	<table class="table table-bordered">
					    <tbody class="">
					    	<tr class='thCenter'  style="background-color:#ddd;">
					    	    <th style="width:7%">项目编码</th>
					    		<th style="width:6%">项目名称</th>
					    		<th style="width:7%">申请服务</th>
					    		<th style="width:10%">调用总次数</th>
					    		<th style="width:7%">任务数</th>
					    		<th style="width:6%">完成率</th>
					    		<th style="width:8%">合同图片</th>
					    		<th style="width:9%">创建人</th>
					    		<th style="width:7%">状态</th>
					    		<th style="width:9%">创建时间</th>
					    		<th style="width:10%">统计时间节点</th>
					    		<th style="width:14%">操作</th>
					    	</tr>
					    	<#if adminServiceApplys?? && (adminServiceApplys?size > 0)>
				         	  <#list adminServiceApplys as adminServiceApply>
					    		<tr class="tableTr tdCenter" applyid="${adminServiceApply.id}">
					    		<td>${adminServiceApply.projectId}</td>
					    		<td>${adminServiceApply.project.name}</td>
					    		<td>
					    			<#if adminServiceApply.majorTypes?? && (adminServiceApply.majorTypes?size>0)>
	   								   <#list adminServiceApply.majorTypes as majorType>
	   		                              ${majorType.name} <#if majorType_has_next>,</#if>
	   		                           </#list>
   								    </#if>
								</td>
					    		<td>${adminServiceApply.callCount}</td>
					    		<td>${adminServiceApply.taskCount}</td>
					    		<td>${adminServiceApply.callCount/adminServiceApply.project.callNumber}%</td>
					    		<td><a href="javascript:void(0)" applyid="${adminServiceApply.id}" class="showAgreementModel">查看</a></td>
					    		<td>${adminServiceApply.creator.name}</td>
					    		<td id="service_${adminServiceApply.id}">${adminServiceApply.statusStr}</td>
					    		<td>${adminServiceApply.createTime?string('yyyy-MM-dd HH:mm:ss')!""}</td>
					    		<td>${.now?string('yyyy-MM-dd HH:mm:ss')!""}</td>
					    		<td>
					    			<button class="info btn btn-success" applyid="${adminServiceApply.id}">详情</button>
					    			<#if adminServiceApply.applyStatus == 'created'>
					    			<button id="approve_${adminServiceApply.id}" class="btn btn-success approve" applyid="${adminServiceApply.id}">审批</button>
					    			<button id="delete_${adminServiceApply.id}" class="btn btn-danger deleteService" applyid="${adminServiceApply.id}">关闭</button>
					    			<#else>
					    			<input type="button" class="btn" style="width:54px;height:30px;background-color:#fff;border:none;cursor: default;outline: none;box-shadow: none">
					    			<input type="button" class="btn" style="width:54px;height:30px;background-color:#fff;border:none;cursor: default;outline: none;box-shadow: none">
					    			</#if>
					    			<input id="approve_hide_${adminServiceApply.id}" class="btn btn-success" style='display:none;width:54px;height:30px;background-color:#fff;border:none;cursor: default;outline: none;box-shadow: none'>
					    			<input id="delete_hide_${adminServiceApply.id}" class="btn btn-success" style='display:none;width:54px;height:30px;background-color:#fff;border:none;cursor: default;outline: none;box-shadow: none'>
					    		</td>
					    		</tr>
					    	   </#list>
					    	</#if>
					    </tbody>
					</table>
  			    </div>
  		        <div id="table_paginator" style="margin-top: -20px; margin-bottom: -10px; text-align:center; display:block;">
				</div>		
  			</div>
    	</div>
    	<!--弹框-->
    	<div class="modal fade" id="server-management-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			      	<input id="applyId" type="hidden" >
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel"></h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
			                <h5><strong>项目信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">名称：</td>
			                			<td><input  class="application-name total newline" type="text" id="ser-name" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">地址：</td>
			                			<td><input  class="application-name total newline" type="text" id="ser-address"/></td>
			                		<tr>
			                			<td class="wid">联系人：</td>
			                			<td><input  class="application-name total newline" type="text" id="ser-phone-person"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">联系方式：</td>
			                			<td><input  class="application-name total newline" type="text" id="ser-phone"/></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			           	<div class="form-group" id="upload-book-div">
			                <h5><strong>合同信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr id="contracted-value-tr">
			                			<td class="wid">合同金额：</td>
			                			<td>
				                			¥
				                			<input type="text" placeholder="请输入金额" class="money-style" id="contracted-value">
				                			元人民币
				                		</td>
			                		</tr>
			                		<tr id="contracted-no-tr">
			                			<td class="wid">合同编号：</td>
			                			<td><input class="application-name total" type="text" id="contracted-no"  placeholder="输入合同编号"/></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>	
			      	    <div class="form-group">
			                <h5><strong>服务信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">申请服务：</td>
			                			<td>
			                				<select class="selectpicker" multiple id="server-type">
											<#if majorTypes?? && (majorTypes?size > 0)>
				         						<#list majorTypes as majorType>
					      							 <option value='${majorType.id}'>${majorType.description}</option>
					     						</#list>
				     						</#if>
											</select>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">项目类型：</td>
			                			<td>
			                				<select id="project-type" class="select-style">
			                				    <option value=''>选择项目类型</option>
					      						<option value='free'>免费测试</option>
					      						<option value='paid'>付费测试</option>
					      						<option value='official'>正式合同</option>
											</select>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">项目开始时间：</td>
			                			<td>
			                				<div class="form-group" id="startTime">							          							                  
							                    <div style="float: left" class=" input-group date form_datetime1 " data-date="2016-11-1T05:25:07Z" data-date-format="yyyy-mm-dd hh:ii:ss" >
								                    <input class="form-control" size="16" type="text" value="" id="fromDate" name="fromDate">
								                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
								                </div>							               
							                </div>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">项目结束时间：</td>
			                			<td>
			                				<div class="form-group" id="endTime">							             							            
							                    <div style="float: left" class=" input-group date form_datetime2 " data-date="2016-11-1T05:25:07Z" data-date-format="yyyy-mm-dd hh:ii:ss" >
								                    <input class="form-control" size="16" type="text" value="" id="toDate" name="toDate">
								                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
								                </div>							                 
							                </div>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">门店数：</td>
			                			<td><input class="application-name total" type="text" id="store-no"  placeholder="输入门店数"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">图片数：</td>
			                			<td><input  class="application-name total newline" type="text" id="pic-number" placeholder="请输入图片数"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">申请次数：</td>
			                			<td><input  class="application-name total newline" type="text" id="application-number" placeholder="输入申请次数"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">调用率提醒：</td>
			                			<td>
			                				<input id="threshhold" type="number" min="1" max="100" style="width:50px;">%
			                				<#-- <input type="checkbox" style="margin-left:20px;">邮件提醒 -->
			                			</td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			      	    <div class="form-group">
			                <h5><strong>账户信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">申请用户名：</td>
			                			<td><input  class="application-name total newline" type="text" id="ser-user-name"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">邮箱：</td>
			                			<td><input  class="application-name total newline" type="text" id="ser-email"/></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>	
			      	    <div id="rejectReasonDiv" class="form-group">
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">驳回原因：</td>
			                			<td><!-- <input id="rejectReason" style="width:100%;height:100%" class="application-name" type="text" /> -->
			                			  <select id="rejectReason" style="width:70%;height: 34px;">
  											<option value="">请选择驳回原因</option>
  											<option value="用户已存在">用户已存在</option>
  											<option value="合同不完整">合同不完整</option>
  										</select>
			                			</td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			      	</div>
			      	<div class="modal-footer">
			        	<button id="openService" type="button" class="btn btn-success" >立即开通</button>
			        	<button id="rejectService" type="button" class="btn btn-danger">驳回</button>
			        	<button id="sure" type="button" style="display:none;" class="btn btn-success"  data-dismiss="modal">确定</button>
			      	</div>
			      	<div class="form-group has-feedback" style='margin-left: 170px; margin-top: -55px;position: absolute;'>
	      	    		<font color="red" id="errorMsg"></font>
	      			</div>
			    </div>
		  	</div>
		</div>
		<div class="modal fade" id="showagreementModel" tabindex="-1" role="dialog" aria-labelledby="showagreementLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header" style='height: 44px;'>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h4  class="modal-title pull-left">合同预览</h4>
					</div>
					<div class="modal-body">
				        <!-- <div class="form-group" >
				             <div style="border:1px solid #000"></div>
				        </div> -->
				        <div class='form-group'>
				           <!-- <div class="row" id="agreement-show"></div> -->				           
				           <div id="carousel-example-generic" class="carousel slide" >
							  <div class="carousel-inner" role="listbox" id='agreement-show'>
							   				 
							  </div>
							  <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
							    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
							    <span class="sr-only">Previous</span>
							  </a>
							  <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
							    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
							    <span class="sr-only">Next</span>
							  </a>
							</div>
				           
				        </div>
					</div>
					<div class="modal-footer" style="border-top-color: #fff;padding: 0px 15px 15px 15px;">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
<div class="modal fade" id="deleteServiceModal" tabindex="-1" role="dialog" aria-labelledby="deleteServiceModalLabel">
	<div class="modal-dialog" role="document">
	     <div class="modal-content">
	         <div class="modal-header">
	             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	             <h4 class="modal-title" id="deleteServiceModalLabel">确认关闭</h4>
	         </div>
	         <div class="modal-body">
	            <p>确认关闭吗？<#-- <b>(一旦删除将不可恢复，请谨慎操作！)</b> --></p>  
	        </div>
	        <div class="modal-footer" style="border-top-color: #ffffff">
	             <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	             <button type="button" class="btn btn-success" id="service_delete">确定</button>
	        </div>
	   </div>
	</div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/adminService.js"></script>
<script type="text/javascript">
	$(function() {
		var currentPage = "${currentPage}";
		var totalCount = "${totalCount?c}";
		adminService.serviceManageInit(currentPage, totalCount);
	});
</script>
