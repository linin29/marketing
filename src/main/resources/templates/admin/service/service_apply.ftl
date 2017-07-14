	<div class="panel panel-default clearBottom">
  			<div class="panel-heading">服务申请</div>
  			<div class="panel-body">
    			<div id="request-header" class="row">
					<div class="col-sm-3">
  						<input id="appBusinessName" <#if appBusinessName??> value="${appBusinessName}"</#if> type="text" class="form-control" placeholder="请输入应用商名称">
					</div>
					<div class="col-sm-3">
					<input id="initApplyStatus" type="hidden" <#if applyStatus??> value="${applyStatus}"</#if>>
  						<select id="applyStatus" style="width:70%;height: 34px;">
  							<option value="">请选择状态</option>
  							<option value="created">已创建</option>
  							<option value="opened">已开通</option>
  							<option value="rejected">已驳回</option>
  						</select>
					</div>
					<div class="col-sm-3">
  						<input id="query" type="button" class=" btn btn-success" value="搜索" style="width:100px;" />
					</div>
					<div class="col-sm-3">
  						<input type="button" class=" btn btn-success new-server" id="new-server" value="新建申请" />
					</div>
				</div>
  			    <div id="request-content">
  			    	<table class="table table-bordered">
					    <tbody class="">
					    	<tr>
					    		<th style="width:5%">申请Id</th>
					    		<th style="width:10%">创建人</th>
					    		<th style="width:20%">应用商</th>
					    		<th style="width:20%">申请服务</th>
					    		<th style="width:8%">调用总次数</th>
					    		<th style="width:7%">合同图片</th>
					    		<th style="width:5%">状态</th>
					    		<th style="width:10%">创建时间</th>
					    		<th style="width:15%">操作</th>
					    	</tr>
					    	<#if adminServiceApplys?? && (adminServiceApplys?size > 0)>
				         		<#list adminServiceApplys as adminServiceApply>
					    	<tr>
					    		<td>${adminServiceApply.id}</td>
					    		<td>${adminServiceApply.creator.name}</td>
					    		<td>${adminServiceApply.appBusinessName}</td>
					    		<td><p class="newline">
					    		   <#if adminServiceApply.majorTypes?? && (adminServiceApply.majorTypes?size>0)>
	   								   <#list adminServiceApply.majorTypes as majorType>
	   		                              ${majorType.name} <#if majorType_has_next>,</#if>
	   		                           </#list>
   								    </#if>
									</p></td>
					    		<td>${adminServiceApply.maxCallNumber}</td>
					    		<td><a href="javascript:void(0)">查看</a></td>
					    		<td>${adminServiceApply.statusStr}</td>
					    		<td>${adminServiceApply.createTime}</td>
					    		<td>
					    			<button class="info btn btn-success" applyid="${adminServiceApply.id}">详情</button>
					    			<button class="btn btn-success" id="modify">变更（更正）</button>
					    		</td>
					    	</tr>
					    	     </#list>
					    	</#if>
					    </tbody>
					</table>
  			    </div>
  		        <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;">
				</div>		
  			</div>
    	</div>
    	<!--弹框-->
    	<div class="modal fade" id="new-server-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel">新建申请</h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
			                <h5><strong>应用商信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">名称：</td>
			                			<td><input  class="application-name" type="text" id="ser-name" placeholder="输入名称"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">地址：</td>
			                			<td><input  class="application-name" type="text" id="ser-address" placeholder="输入地址"/></td>
			                		<tr>
			                			<td class="wid">联系人：</td>
			                			<td><input  class="application-name" type="text" id="ser-phone-person" placeholder="输入联系人"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">联系方式：</td>
			                			<td><input  class="application-name" type="text" id="ser-phone" placeholder="输入联系方式"/></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			           	<div class="form-group">
			                <h5><strong>合同信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr id="upload-book-tr">
			                			<td class="wid">上传合同：</td>
			                			<td><input  class="application-name" type="file" id="upload-book" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">合同张数：</td>
			                			<td><input  class="application-name" type="text" id="agreement-number" placeholder="输入合同张数"/></td>
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
			                				<select class="selectpicker" multiple id="server-type" id="ser-type">
											<#if majorTypes?? && (majorTypes?size > 0)>
				         						<#list majorTypes as majorType>
					      							 <option value='${majorType.name}'>${majorType.description}</option>
					     						</#list>
				     						</#if>
											</select>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">申请次数：</td>
			                			<td><input  class="application-name" type="text" id="application-number" placeholder="输入申请次数"/></td>
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
			                			<td><input  class="application-name" type="text" id="ser-user-name" placeholder="输入用户名"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">邮箱：</td>
			                			<td><input  class="application-name" type="text" id="ser-email" placeholder="输入邮箱"/></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>	
			      	    <!-- <div class="form-group">
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">通知管理员：</td>
			                			<td>
			                				<select class="selectpicker" multiple id="admin-type" id="admin-number">
											    <#if adminUsers?? && (adminUsers?size > 0)>
				         						<#list adminUsers as adminUser>
					      							 <option value='${adminUser.id}'>${adminUser.name}</option>
					     						</#list>
				     						</#if>
											</select>
			                			</td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div> -->
			      	</div>
			      	<div class="modal-footer">
			        	<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
			        	<button id="saveService" type="button" class="btn btn-success">保存</button>
			      	</div>
			    </div>
		  	</div>
		</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/adminService.js"></script>
<script type="text/javascript">
	$(function() {
		var currentPage = "${currentPage}";
		var totalCount = "${totalCount?c}";
		adminService.serviceApplyInit(currentPage, totalCount);
	});
</script>