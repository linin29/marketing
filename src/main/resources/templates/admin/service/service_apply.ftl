	<div class="panel panel-default clearBottom">
  			<div class="panel-heading">服务申请</div>
  			<div class="panel-body">
    			<div id="request-header" class="row">
					<div class="col-sm-3">
  						<input type="text" class="form-control" placeholder="请输入应用商品名称">
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
					<div class="col-sm-3">
  						<input type="button" class=" btn btn-success new-server" id="new-server" value="新建申请" />
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
					    		<td id="application-Id">1</td>
					    		<td id="create-user">admin</td>
					    		<td id="application-company">家乐福天鹅湖店</td>
					    		<td id="application-server" style="width: 80px;"><p class="newline">coffe，cookie，coffee，cof</p></td>
					    		<td id="numbers">10000</td>
					    		<td id="image"><a href="###">查看</a></td>
					    		<td id=status>已创建</td>
					    		<td id="ser-number">2017/5/4</td>
					    		<td>
					    			<button class="btn btn-success" id='info'>详情</button>
					    			<button class="btn btn-success" id="modify">变更（更正）</button>
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
			                			<td><input  class="application-name" type="text" id="ser-name"/></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">地址：</td>
			                			<td><input  class="application-name" type="text" id="ser-address" /></td>
			                		<tr>
			                			<td class="wid">联系人：</td>
			                			<td><input  class="application-name" type="text" id="ser-phone-person" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">联系方式：</td>
			                			<td><input  class="application-name" type="text" id="ser-phone" /></td>
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
			                			<td><input  class="application-name" type="file" id="upload-book" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">合同张数：</td>
			                			<td><input  class="application-name" type="text" id="agreement-number"/></td>
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
											    <option>服务1</option>
											    <option>服务2</option>
											    <option>服务3</option>
											</select>
			                			</td>
			                		</tr>
			                		<tr>
			                			<td class="wid">申请次数：</td>
			                			<td><input  class="application-name" type="text" id="application-number" /></td>
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
			                			<td><input  class="application-name" type="text" id="ser-user-name" /></td>
			                		</tr>
			                		<tr>
			                			<td class="wid">邮箱：</td>
			                			<td><input  class="application-name" type="text" id="ser-email" /></td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>	
			      	    <div class="form-group">
			                <table class="table table-bordered" style="width: 90%;">
			                	<tbody>
			                		<tr>
			                			<td class="wid">通知管理员：</td>
			                			<td>
			                				<select class="selectpicker" multiple id="admin-type" id="admin-number">
											    <option>管理员1</option>
											</select>
			                			</td>
			                		</tr>
			                	</tbody>
			                </table>
			           	</div>
			      	</div>
			      	<div class="modal-footer">
			        	<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
			        	<button type="button" class="btn btn-success">保存</button>
			      	</div>
			    </div>
		  	</div>
		</div>
		<script type="text/javascript">
			$(function(){
				$("#new-server").click(function(){
					$("#new-server-model").modal("show");
				});
				$("#modify").click(function(){
					$("#myModalLabel").text("修改申请");	
					$("#new-server-model").modal("show");
				})
				$("#info").click(function(){					
				 var cont=$('#application-company').text(); 
				 $("#myModalLabel").text("服务申请详情");	
					$("#new-server-model").modal("show");
					$("#ser-name").val(cont);
				})
				$('#server-type').selectpicker({
		        	width:"100%"
		        });
		        $('#admin-type').selectpicker({
		        	width:"100%"
		        });
			})
		</script>