<div class="panel panel-default clearBottom">
  			<div class="panel-heading">服务管理</div>
  			<div class="panel-body">
    			<div id="request-header" class="row">
					<div class="col-sm-3">
  						<input type="text" class="form-control" placeholder="请输入应用商名称">
					</div>
					<div class="col-sm-3">
  						<select style="width:70%;height: 34px;">
  							<option value="">请选择状态</option>
  							<option value="created">已创建</option>
  							<option value="opened">已开通</option>
  							<option value="rejected">已驳回</option>
  						</select>
					</div>
					<div class="col-sm-3">
  						<input type="button" class=" btn btn-success" value="搜索" style="width:100px;" />
					</div>
				</div>
  			    <div id="request-content">
  			    	<table class="table table-bordered">
					    <tbody class="">
					    	<tr>
					    		<th>申请Id</th>
					    		<th>创建人</th>
					    		<th>应用商</th>
					    		<th>申请服务</th>
					    		<th>调用总次数</th>
					    		<th>合同图片</th>
					    		<th>状态</th>
					    		<th>创建时间</th>
					    		<th>操作</th>
					    	</tr>
					    	<tr>
					    		<td>1</td>
					    		<td>admin</td>
					    		<td>家乐福天鹅湖店</td>
					    		<td style="width: 80px;"><p class="newline">coffe，cookie，coffee，cof</p></td>
					    		<td>10000</td>
					    		<td><a href="###">查看</a></td>
					    		<td>已创建</td>
					    		<td>2017/5/4</td>
					    		<td>
					    			<button class="btn btn-success" id="server-info">详情</button>
					    			<button class="btn btn-success" id="approval">审批</button>
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
    	<div class="modal fade" id="server-management-model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  	<div class="modal-dialog" role="document">
			    <div class="modal-content">
			      	<div class="modal-header">
			        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        	<h4 class="modal-title" id="myModalLabel"></h4>
			      	</div>
			      	<div class="modal-body">
			        	<div class="form-group">
			                <h5><strong>应用商信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">名称：</td>
			                			<td><input  class="application-name" type="text" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">地址：</td>
			                			<td><input  class="application-name" type="text" /></td>
			                		<tr>
			                			<td class="wid">联系人：</td>
			                			<td><input  class="application-name" type="text" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">联系方式：</td>
			                			<td><input  class="application-name" type="text" /></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			           	<div class="form-group">
			                <h5><strong>合同信息</strong></h5>
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">上传合同：</td>
			                			<td><input  class="application-name" type="file" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">合同张数：</td>
			                			<td><input  class="application-name" type="text" /></td>
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
											    <option>服务1</option>
											    <option>服务2</option>
											    <option>服务3</option>
											</select>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">申请次数：</td>
			                			<td><input  class="application-name" type="text" /></td>
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
			                			<td><input  class="application-name" type="text" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">邮箱：</td>
			                			<td><input  class="application-name" type="text" /></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>	
			      	    <div class="form-group">
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">驳回原因：</td>
			                			<td><input  class="application-name" type="text" /></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			      	</div>
			      	<div class="modal-footer">
			        	<button type="button" class="btn btn-success" >立即开通</button>
			        	<button type="button" class="btn btn-danger">驳回</button>
			      	</div>
			    </div>
		  	</div>
		</div>
		<script type="text/javascript">
			$(function(){
				$("#server-info").click(function(){
					$("#myModalLabel").text("服务管理详情");	
					$("#server-management-model").modal("show");
				});
				$("#approval").click(function(){
					$("#myModalLabel").text("服务管理审批");
					$("#server-management-model").modal("show");
				});
				$('#server-type').selectpicker({
		        	width:"100%"
		        });
		        $('#admin-type').selectpicker({
		        	width:"100%"
		        });
			})
		</script>
