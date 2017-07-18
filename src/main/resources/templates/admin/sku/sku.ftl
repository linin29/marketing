<style type="text/css">
	.th_center th{
		text-align:center;
	}
	.th_center{
		background-color:#ddd;
	}
</style>
<div class="panel panel-default clearBottom">
	<div class="panel-heading">SKU配置</div>
	<div class="panel-body">
		<div id="request-header" class="row">
			<div class="col-sm-3">
				<select id="skuType" style="width:70%;height: 34px;">
					<option value="">请选择类型</option>
					<#if majorTypes?? && (majorTypes?size > 0)>
			       		<#list majorTypes as majorType>
			     		 <option value='${majorType.name}' >${majorType.description}</option>
			    		</#list>
		   			</#if>
				</select>
			</div>
			<div class="col-sm-3">
				<input type="button" class=" btn btn-success" id="search" value="搜索" style="width:100px;" />
			</div>
			<div class="new-type">
				<input type="button" class=" btn btn-success new-server" id="new-SKU" value="新建类型" />
			</div>
		</div>
	    <div id="type-content">
	    	<table class="table table-bordered">
			    <tbody class="">
			    	<tr class='th_center'>
			    		<th style="width:20%">名称</th> 
			    		<th style="width:20%"">类型</th>
			    		<th style="width:15%"">描述</th>
			    		<th style="width:15%"">是否显示</th>
			    		<th style="width:15%"">创建时间</th>
			    		<th style="width:15%"">操作</th>
			    	</tr>
			    	<#list GoodsSkus as GoodsSku>
			    	<tr style="text-align:center;" class="tdstyle ${GoodsSku.id!}" skuid=${GoodsSku.id!} >
			    		<td class='name'>${GoodsSku.name!}</td>
			    		<td class='type' >${GoodsSku.description!}</td>
			    		<td style="width: 150px;"><p class="newline description">${GoodsSku.description!}</p></td>
			    		<td class='showOrNot'>${GoodsSku.isShow?string("是","否")}</td>
			    		<td >${GoodsSku.createTime!}</td>
			    		<td>
			    			<button class="btn btn-success" id="modify_${GoodsSku.id!}" onclick="sku.edit(this, ${GoodsSku.id});">修改</button>
			    			<button class="btn btn-danger deleteSkuModel" skuid="${GoodsSku.id}">删除</button>
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
<div class="modal fade" id="new-SKU-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog" role="document">
	    <div class="modal-content">
	      	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        	<h4 class="modal-title" id="myModalLabel"></h4>
	      	</div>
	      	<input id="skuId" type="hidden" >
	      	<div class="modal-body">
	        	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >名称：</span>
                    <div class="col-sm-9 ">
                        <input id="sku_name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入名称">
                    </div>
              	</div>
              	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >类型：</span>
                    <div class="col-sm-9 " style="margin-bottom: 24px">
	                    <select id="sku_select" style="width: 100%;height: 34px;">
	                        <option value="alert">请选择类型</option>
	                    </select>
                  		</div>
              	</div>
              	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >描述：</span>
                    <div class="col-sm-9 ">
                        <input id="sku_description" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入描述信息">
                    </div>
              	</div>
              	<div class="form-group">
                    <span class="control-label col-sm-3 text-right" >是否显示：</span>
                    <div class="col-sm-9 " style="margin-bottom: 24px">
	                   <select id="sku_or_not" style="width: 100%;height: 34px;">
	                       <option value="true">是</option>
	                       <option value="false">否</option>
	                   </select>
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
<div class="modal fade" id="deleteSkuModal" tabindex="-1" role="dialog" aria-labelledby="deleteAreaModalLabel">
	<div class="modal-dialog" role="document">
	     <div class="modal-content">
	         <div class="modal-header">
	             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	             <h4 class="modal-title" id="deleteSkuModalLabel">确认删除</h4>
	         </div>
	         <div class="modal-body">
	            <p>确认删除吗？<b>(一旦删除将不可恢复，请谨慎操作！)</b></p>  
	        </div>
	        <div class="modal-footer" style="border-top-color: #ffffff">
	             <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	             <button type="button" class="btn btn-success" id="sku_delete">确定</button>
	        </div>
	   </div>
	</div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/sku.js"></script>
<script type="text/javascript">
	$(function() {
		var currentPage = "${currentPage}";
		var totalCount = "${totalCount?c}";
		sku._init(currentPage, totalCount);
	});
</script>
