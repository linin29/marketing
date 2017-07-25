<div class="personCenter">
	<form role="form" id="profileForm" action="${springMacroRequestContext.contextPath}/admin/user/personcenter/password" method="post">
   <div class="panel panel-default">
       <div class="panel-heading">个人中心</div>
       <div class="panel-body">
           <div class="form-group">
               <div class="input-group ">
               		<input name="id" type="hidden" value="${admin_user.id}">
                   <span class="input-group-addon">用户名</span>
                   <input type="text" class="form-control" placeholder="${admin_user.name}" readonly="readonly" style="width: 196px">
               </div>
           </div>
           <div class="form-group">
               <div class="input-group ">
                   <span class="input-group-addon" style="width:68px">邮箱</span>
                   <input type="email" class="form-control" readonly="readonly" style="width: 196px" placeholder="${admin_user.email}">
               </div>
           </div>
           <div class="form-group">
               <div class="input-group ">
                   <span class="input-group-addon" style="width:68px">密码</span>
                   <input type="password" class="form-control" readonly="readonly" placeholder="******" style="width: 196px">
               </div>
           </div>
           <div class="form-group">
               <button type="button" class="btn btn-success" data-toggle="modal" data-target=".bs-example-modal-sm">修改</button>
               		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="modelUpdate">
                  		 <div class="modal-dialog modal-sm">
                      		 <div class="modal-content">
                               <div class="panel panel-default">
                               <div class="panel-heading">修改密码</div>
                               <div class="panel-body">
                                   <div class="form-group">
                                       <p>原始密码</p>
                                       <input class="form-control required" id="password" name="password" placeholder="原始密码" required="" type="password">
                                   </div>
                                   <div class="form-group">
                                       <p>新密码</p>
                                       <input class="form-control required" id="newPassword" name="newPassword" placeholder="新密码" required="" type="password">
                                   </div>
                                   <div class="form-group">
                                       <p>确认密码</p>
                                       <input class="form-control required" id="confirmPassword" placeholder="确认密码" required="" type="password">
                                   </div>
                                   <div id="errorMsg" style="color:red; margin-bottom: 5px"></div>
                                   <div class="form-group">
                                       <button type="button" class="btn btn-success" id="submitProfile" onclick="revise()">确认修改</button>
                                       <button type="button" data-dismiss="modal" class="btn btn-default pull-right">取消</button>
                                   </div>
                               </div>
                           </div>
                       </div>
                   </div>
              	 </div>
           </div>
       </div>
   </div>
   </form>
</div>
<script type="text/javascript">
	function revise(){
		var password = $('#password').val().trim();
        var newPassword = $('#newPassword').val().trim();
        var confirmPassword = $('#confirmPassword').val().trim();
        if(password=='' || newPassword=='' || confirmPassword==''){
            $('#errorMsg').text('所有字段均为必填！');
            return;
        }else if(password==newPassword){
            $('#errorMsg').text('新旧密码不能一样！');
            return;
        }else if(confirmPassword!=newPassword){
            $('#errorMsg').text('新密码确认不一致！');
            return;
        }else if(!/^.{6,20}$/.test(newPassword)){
            $('#errorMsg').text('密码长度应在6-20个字符之间！');
            return;
        }
        tunicorn.utils.postForm($('#profileForm'), function(err, data){
            if(err){
               noty({text: "sorry,error", layout: "topCenter", type: "error", timeout: 2000});
               return;
            }
            if(data && data.success){
            	$("#modelUpdate").modal('hide');
            	noty({text: "更新密码成功！", layout: "topCenter", type: "success", timeout: 2000});
            	setTimeout(function(){
            		tunicorn.utils.render('${springMacroRequestContext.contextPath}/admin/user/personcenter');
            	},500);
            }else{
               noty({text: "更新密码失败", layout: "topCenter", type: "error", timeout: 2000});
            }
        });
	}
</script>