<div class="panel-default clearBottom">
	<div class="panel-heading">主类型配置</div>
	<div class="panel-body">
		<div id="request-header" class="row" style='margin-left:-14px;'>
			<div class="new-type">
				 <input type="button" class=" btn btn-success new-server" id="new-type" value="新建类型" />
			</div>
		</div> 
	    <div id="type-content">
	    	<table class="table table-bordered">
		    	<tbody class="">
		    		<tr style="background-color:#ddd;">
			    		<th style="text-align:center;width:25%">名称</th>
			    		<th style="text-align:center;width:25%">描述</th>
			    		<th style="text-align:center;width:9%">版本</th>
			    		<th style="text-align:center;width:20%">创建时间</th>
			    		<th style="text-align:center;width:20%">操作</th>
		    		</tr>
		    		<#if majorTypes?? && (majorTypes?size > 0)>
		    			<#list majorTypes as majorType>
		    				<tr class="tableTr" majortypeid=${majorType.id} style="text-align:center">
			    				<td class="name">${majorType.name!""}</td>
			    				<td class="description" style="width: 80px;"><p class="newline">${majorType.description!""}</p></td>
			    				<td class="version"><p class="newline">${majorType.version!""}</p></td>
			    				<td>${majorType.createTime?string('yyyy-MM-dd HH:mm:ss')!""}</td>
			    				<td>
			    					<button class="btn btn-success" id="modify_${majorType.id!}" onclick="majorType.edit(this, ${majorType.id});">修改</button>
			    					<button class="btn btn-danger deleteMajorType" majortypeid="${majorType.id}">删除</button>
			    				</td>
		    				</tr>
		    			</#list>
		    		</#if>
		    	</tbody>
			</table>
			<div id="table_paginator" style="margin-top: -20px; margin-bottom: -10px; text-align:center; display:block;"></div>
	    </div>	
  	</div>
</div>
 <!--弹框-->
<div class="modal fade" id="new-type-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog" role="document">
	    <div class="modal-content">
	      	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        	<h4 class="modal-title" id="myModalLabel">新建类型</h4>
	      	</div>
	      	<input id="majorTypeId" type="hidden" >
	      	<div class="modal-body">
	        	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >名称：</span>
                    <div class="col-sm-9 ">
                        <input id="deploy_name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入名称">
                    </div>
              	</div>
              	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >版本：</span>
                    <div class="col-sm-9 ">
                        <input id="deploy_version" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入版本，如1.0">
                    </div>
              	</div>
              	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >描述：</span>
                    <div class="col-sm-9 ">
                        <input id="deploy_des" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入描述信息">
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
<div class="modal fade" id="deleteMajorTypeModal" tabindex="-1" role="dialog" aria-labelledby="deleteMajorTypeModalLabel">
	<div class="modal-dialog" role="document">
	     <div class="modal-content">
	         <div class="modal-header">
	             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	             <h4 class="modal-title" id="deleteMajorTypeModalLabel">确认删除</h4>
	         </div>
	         <div class="modal-body">
	            <p>确认删除吗？<b>(一旦删除将不可恢复，请谨慎操作！)</b></p>  
	        </div>
	        <div class="modal-footer" style="border-top-color: #ffffff">
	             <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	             <button type="button" class="btn btn-success" id="majorType_delete">确定</button>
	        </div>
	   </div>
	</div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/major_type.js"></script>
<script type="text/javascript">
	$(function(){
		var currentPage='${currentPage}';
		var totalCount='${totalCount?c}';
		majorType._init(currentPage,totalCount);	
	})
</script>
