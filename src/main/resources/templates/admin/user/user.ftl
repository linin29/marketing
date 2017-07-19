<style type="text/css">
	.th_center th{
		text-align:center;
	}
	.th_center{
		background-color:#ddd;
	}
</style>
<div class="panel-default clearBottom">
	<div class="panel-heading">用户管理</div>
	<div class="panel-body">
	<!-- 	<div id="request-header" class="row">
			<div class="col-sm-3">
				<select id="skuType" style="width:70%;height: 34px;">
					<option value="">请选择类型</option>
					<#if majorTypes?? && (majorTypes?size > 0)>
			       		<#list majorTypes as majorType>
			     		 <option value='${majorType.name}' <#if initMajorType??&&  majorType.name=='${initMajorType}'> selected </#if>>${majorType.description}</option>
			    		</#list>
		   			</#if>
				</select>
			</div> 
			<div class="col-sm-3">
				<input type="button" class=" btn btn-success" id="search" value="搜索" style="width:100px;" />
			</div>
			<div class="new-type">
				<input type="button" class=" btn btn-success new-server" id="new-SKU" value="新建" />
			</div>
		</div> -->
	    <div id="type-content">
	    	<table class="table table-bordered">
			    <tbody class="">
			    	<tr class='th_center'>
			    		<th style="width:20%">用户ID</th> 
			    		<th style="width:20%"">用户名</th>
			    		<th style="width:15%"">邮箱</th>
			    		<th style="width:15%"">操作</th>
			    	</tr>
			    	<#list users as user>
			    	<tr style="text-align:center;" class="tableTr" userid=${user.id!} >
			    		<td class='userid'>${user.id!""}</td>
			    		<td class='name'>${user.userName!""}</td>
			    		<td class='email' >${user.email!""}</td>
			    		<td>
			    			<button class="btn btn-success resetPwdModel" userid=${user.id}>重置密码</button>
			    			<button class="btn btn-success updateUserModel" onclick="user.edit(this, '${user.id}');">修改</button>
			    		</td>
			    	</tr>
			    	</#list>
			    </tbody>
			</table>
	    </div>
        <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;">
		</div>	
  	</div>
</div>
<!--弹框-->
<div class="modal fade" id="new-user-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog" role="document">
	    <div class="modal-content">
	    <input id="userId" type="hidden" >
	      	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        	<h4 class="modal-title" id="myModalLabel"></h4>
	      	</div>
	      	<input id="skuId" type="hidden" >
	      	<div class="modal-body">
	        	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >邮箱：</span>
                    <div class="col-sm-9 ">
                        <input id="email" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入邮箱">
                    </div>
              	</div>
	      	</div>
	      	<div class="cl"></div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	        	<button type="button" class="btn btn-success" id="save">保存</button>
	      	</div>
	      	<div class="form-group has-feedback" style='margin-left: 170px; margin-top: -55px;position: absolute;'>
	      	    <font color="red" id="errorMsg"></font>
	      	</div>
	    </div>
  	</div>
</div>
<div class="modal fade" id="resetPwdModal" tabindex="-1" role="dialog" aria-labelledby="resetPwdModalLabel">
	<div class="modal-dialog" role="document">
	     <div class="modal-content">
	         <div class="modal-header">
	             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	             <h4 class="modal-title" id="deleteAreaModalLabel">重置密码</h4>
	         </div>
	         <div class="modal-body">
	            <p>确认重置密码吗？<b>(密码将被重置为tiannuo！)</b></p>  
	        </div>
	        <div class="modal-footer" style="border-top-color: #ffffff">
	             <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	             <button type="button" class="btn btn-success" id="user_resetPwd">确定</button>
	        </div>
	   </div>
	</div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/user.js"></script>
<script type="text/javascript">
	$(function() {
		var currentPage = "${currentPage}";
		var totalCount = "${totalCount?c}";
		user._init(currentPage, totalCount);
	});
</script>
