<div class="panel panel-default clearBottom">
  			<div class="panel-heading">SKU配置</div>
  			<div class="panel-body">
    			<div id="request-header" class="row">
    				<div class="col-sm-3">
  						<select style="width:70%;height: 34px;">
  							<option value="">请选择类型</option>
  							<#if majorTypes?? && (majorTypes?size > 0)>
				         		<#list majorTypes as majorType>
					      		 <option value='${majorType.name}'>${majorType.description}</option>
					     		</#list>
				     		</#if>
  						</select>
					</div>
					<div class="col-sm-3">
  						<input type="button" class=" btn btn-success" value="搜索" style="width:100px;" />
					</div>
					<div class="new-type">
  						<input type="button" class=" btn btn-success new-server" id="new-SKU" value="新建类型" />
					</div>
				</div>
  			    <div id="type-content">
  			    	<table class="table table-bordered">
					    <tbody class="">
					    	<tr>
					    		<th>名称</th>
					    		<th>类型</th>
					    		<th>描述</th>
					    		<th>创建时间</th>
					    		<th>操作</th>
					    	</tr>
					    	<tr>
					    		<td>coffee</td>
					    		<td>coffee</td>
					    		<td style="width: 150px;"><p class="newline ">cofferetrefferetretrfferetretrtrtcof</p></td>
					    		<td>2017/5/4</td>
					    		<td>
					    			<button class="btn btn-success" id="modify">修改</button>
					    			<button class="btn btn-danger">删除</button>
					    		</td>
					    	</tr>
					    </tbody>
					</table>
  			    </div>
  		        <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;">
					<ul class="pagination">
					    <li><a href="#">&laquo;</a></li>
					    <li><a href="#">1</a></li>
					    <li><a href="#">2</a></li>
					    <li><a href="#">3</a></li>
					    <li><a href="#">4</a></li>
					    <li><a href="#">5</a></li>
					    <li><a href="#">&raquo;</a></li>
					</ul>
				</div>		
  			</div>
    	</div>
    	<!--弹框-->
    	<div class="modal fade" id="new-SKU-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel">新建商品</h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >名称：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入名称">
		                    </div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >类型：</span>
		                    <div class="col-sm-9 " style="margin-bottom: 24px">
			                    <select id="modal-type-select" style="width: 100%;height: 34px;">
			                        <option value="alert">请选择类型</option>
			                    </select>
                    		</div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >描述：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入描述信息">
		                    </div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >是否显示：</span>
		                    <div class="col-sm-9 " style="margin-bottom: 24px">
			                    <select id="modal-type-select" style="width: 100%;height: 34px;">
			                        <option value="alert">是</option>
			                        <option value="alert">否</option>
			                    </select>
                    		</div>
                		</div>
			      	</div>
			      	<div class="cl"></div>
			      	<div class="modal-footer">
			        	<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
			        	<button type="button" class="btn btn-success">保存</button>
			      	</div>
			    </div>
		  	</div>
		</div>
		<!--修改弹框-->
		<div class="modal fade" id="modify-SKU-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel">修改商品信息</h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >名称：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入名称">
		                    </div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >类型：</span>
		                    <div class="col-sm-9 " style="margin-bottom: 24px">
			                    <select id="modal-type-select" style="width: 100%;height: 34px;">
			                        <option value="alert">请选择类型</option>
			                    </select>
                    		</div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >描述：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入描述信息">
		                    </div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >是否显示：</span>
		                    <div class="col-sm-9 " style="margin-bottom: 24px">
			                    <select id="modal-type-select" style="width: 100%;height: 34px;">
			                        <option value="alert">是</option>
			                        <option value="alert">否</option>
			                    </select>
                    		</div>
                		</div>
			      	</div>
			      	<div class="cl"></div>
			      	<div class="modal-footer">
			        	<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
			        	<button type="button" class="btn btn-success">保存</button>
			      	</div>
			    </div>
		  	</div>
		</div>
		<script type="text/javascript">
			$(function(){
				$("#new-SKU").click(function(){
					$("#new-SKU-model").modal("show");
				});
				$("#modify").click(function(){
					$("#modify-SKU-model").modal("show");
				})
			})
		</script>
