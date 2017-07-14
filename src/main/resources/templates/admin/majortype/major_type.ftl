<div class="panel panel-default clearBottom">
  			<div class="panel-heading">主类型配置</div>
  			<div class="panel-body">
    			<div id="request-header" class="row">
					<div class="new-type">
  						<input type="button" class=" btn btn-success new-server" id="new-type" value="新建类型" />
					</div>
				</div>
  			    <div id="type-content">
  			    	<table class="table table-bordered">
					    <tbody class="">
					    	<tr>
					    		<th>名称</th>
					    		<th>描述</th>
					    		<th>创建时间</th>
					    		<th>操作</th>
					    	</tr>
					    	<tr>
					    		<td>coffee</td>
					    		<td style="width: 80px;"><p class="newline">coffe，cookie，coffee，cof</p></td>
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
    	<div class="modal fade" id="new-type-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel">新建类型</h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >名称：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入名称">
		                    </div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >描述：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入描述信息">
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
		<div class="modal fade" id="modify-type-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel">修改类型</h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >名称：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入名称">
		                    </div>
                		</div>
                		<div class="form-group">
		                    <span class="control-label col-sm-3 text-right" >描述：</span>
		                    <div class="col-sm-9 ">
		                        <input id="deploy-name" style="margin-bottom: 24px" type="text" class="form-control" placeholder="请输入描述信息">
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
				$("#new-type").click(function(){
					$("#new-type-model").modal("show");
				});
				$("#modify").click(function(){
					$("#modify-type-model").modal("show");
				})
				$('#server-type').selectpicker({
		        	width:"100%"
		        });
		        $('#admin-type').selectpicker({
		        	width:"100%"
		        });
			})
		</script>
