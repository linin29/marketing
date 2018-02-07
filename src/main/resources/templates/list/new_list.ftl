<style type="text/css">
   body {padding-right:0px !important;}
   img {max-width: 100%;}
</style>
<div class="create_task max_width">
       <ul>
           <li>
               <h4>
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>任务名</span>
                   <span id="status" status="<#if task??>${task.taskStatus}<#else>task_init</#if>" style="margin-left:30px;">(当前状态：
                   	<#if task?? && task.taskStatus=='identify_success' && task.identifySuccessTimes gt 0>
                   		${task.taskStatus}${task.identifySuccessTimes}
                   	<#elseif task?? && (task.taskStatus !='identify_success' || task.identifySuccessTimes == 0)>
                   		${task.taskStatus}
                   	<#else>
                   		task_init
                   	</#if>)
                   </span>
                   <div>
                 	  <input id="taskName" type="text" style='display:inline-block;margin-right: 38px;' <#if task??> value="${task.name}"  readonly= "true" </#if> placeholder="请输入任务名" class="form-control create_task_input">
                 	  <input id="taskMajorType" type="hidden" <#if task?? && task.majorType??> value="${task.majorType}" </#if>>              
             	   	  <button style='width:100px;display:inline-block;' id="nextTask" type="button" class="btn btn-success">下一个任务</button>                   		
                   </div>
               </h4>               
           </li>
           <#if projects?? && (projects?size > 0)>
	           <#if task??><!--编辑-->
		           <#if (task.projectId)?? && task.projectId !=''>
		           <li>
		               <h4>
		               		<img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
		                   	<span>项目</span>
		                   	<div class="modal-body" style="padding-left: 25px;">
		                 	  	<select class="form-control" id="project_id" name="project_id" style="width:300px;" disabled="disabled">
		                 	  	   <option value="">请选择项目</option>
				                       <#list projects as project>
				                       		<option value="${project.id}" <#if (task.projectId)?? && project.id==task.projectId>selected</#if>>${project.name}</option>
				                       </#list>
		                    	</select>
		                   	</div>
		               </h4>
		           </li>
		           </#if>
	           <#else><!--新建-->
	           <li>
	               <h4>
	               		<img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
	                   	<span>项目</span>
	                   	<div class="modal-body" style="padding-left: 25px;">
	                 	  	<select class="form-control" id="project_id" name="project_id" style="width:300px;">
	                 	  	   <option value="">请选择项目</option>
			                       <#list projects as project>
			                       		<option value="${project.id}" <#if (task.projectId)?? && project.id==task.projectId>selected</#if>>${project.name}</option>
			                       </#list>
	                    	</select>
	                   	</div>
	               </h4>
	           </li>
	           </#if>
           </#if>
           <li>
               <h4>
                   <img class="img_icorn" src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>选择货架照片</span>
                   <div class="choose-box-body">
                       <div class="row" style="padding-left: 15px;">
                           <div class="col-xs-1 choose_btn" style="width: 125px;padding-right: 4px;">
                               <span class="btn btn-success btn-sm fileinput-button pull-right">
                                   <img src="${springMacroRequestContext.contextPath}/image/camera_icorn.png" class="st_camera">
                                   <span>上传图片</span>
                                   <form id="image-form" action="#" method="post" enctype="" class="form-horizontal">
                                       <input id="image-upload" type="file" name="images" multiple="multiple" accept="image/jpeg,image/png,image/bmp,image/jpg" class="pic-upload">
                                       <input id="taskId" type="hidden" name="taskId" value="<#if task??>${task.id}<#else>-1</#if>">
                                       <input id="taskLabel" type="hidden" name="taskLabel" <#if task??> value="${task.name}"</#if>>
                                       <input id="projectId" type="hidden" name="projectId" <#if (task.projectId)??> value="${task.projectId}"</#if>>
                                   </form>
                               </span>
                           </div>
                           <div class="col-xs-1 choose_btn" style="width: 100px;">
                                <button id="preview" type="button" class="btn btn-success">预览照片</button>
                           </div>
                           <div  class="col-xs-1 choose_btn" style="width: 100px;">
                               <button id="merge-pre" type="button" class="btn btn-success">拼接图片</button>
                           </div>
                           <div class="col-xs-1 choose_btn" style="width: 100px;">
                                <button id="taskStatus" type="button" class="btn btn-success">获取状态</button>
                           </div>
                           <#if task??>
	                           <div class="col-xs-1 choose_btn" style="width: 100px;">
	                                <a href="${springMacroRequestContext.contextPath}/showView/${task.id}" target="_blank"><button type="button" class="btn btn-success">查看信息</button></a>
	                           </div>
	                       </#if>
	                       <#if task?? && task.taskStatus=='identify_success'>
	                        <div class="col-xs-1 choose_btn" style="width: 100px;">
                                <button id="taskPullData" type="button" class="btn btn-success">拉取数据</button>
                           </div>
                           </#if> 
                       </div>
                   </div>
               </h4>
           </li>
           <li>
               <h4>
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>货架拼接照片</span>
                   <div style="clear:both"></div>                   
                   <div class="row" id="stitch_image">
	                   <div id="image_default"  align="center"  class="col-sm-8">
		                   <#if task?? && task.taskStatus?? && (task.taskStatus!='stitching' && task.taskStatus!='image_uploaded') && task.stitchImagePath??>
		                     <#if task.taskStatus=='identify_success' && stitchBorderImagePath!=''>
		                     	<a href="/pic/marketing${stitchBorderImagePath}" target="_blank">
		                     <#else>
		                     	<a href="/pic/marketing${stitchImagePath}" target="_blank">
		                     </#if>	
		                           <img style="width:auto; height:400px; padding:0;" id="stitched" src="/pic/marketing${stitchImagePath}" class="img-thumbnail static_img">
		                        </a>
		                   <#else>
		                        <a href="${springMacroRequestContext.contextPath}/image/2.png" target="_blank">
		                           <img id="stitched" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img">
		                        </a>
		                   </#if>
	                   </div>
	                   <div class='col-sm-4' style="width:32%;">
	                   	<#if task?? && task.taskStatus?? && task.taskStatus=='identify_success'>
                     		<p id="brandListp" style="font-size:14px;"><strong>品牌列表</strong></p>
                   		</#if>
	                   	<#if task?? && task.taskStatus?? && task.taskStatus=='identify_success'>
		                   <div class="brand-list" >
		                     <#if goodResults?? && (goodResults?size > 0)>
		                       <#list goodResults as goodResult>
		                        <#if goodResult.isShow && (goodResult.num?eval >0)>
		               	         <div class="form-group">
			               		   <span class="icorn-brand"></span>
			               		   <div class="changeline" produce="${goodResult_index}"><a href="javascript:void(0);" onclick="newList.getCrops(${goodResult_index})">${goodResult.goods_desc}(${goodResult.num})</a></div>  
		           			     </div>
		           			    </#if>
		           			   </#list>
		           			 </#if>
			               </div>
		               </#if>                 
	                   </div>
	               </div>
               </h4>
               <div style="clear:both;"></div>
           </li>
           <li>
               <h4 style="padding-bottom: 28px;">
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>货架数据</span>
                   <!-- <button id="count" type="button" class="btn btn-success count_number">统计数据</button> -->
                   <table id="countInfo" class="table table-bordered table-hover table-condensed count_table">
                       <thead>
                            <tr>
                            	<th  colspan="2">货架总层数</th><td colspan="1"><#if rows??>${rows}<#else>0</#if></td>
                            	<th  colspan="2">货架总面积</th><td colspan="1"><#if totalArea??>${totalArea}<#else>0</#if></td>
                            </tr>
                       </thead>
                       <tbody>
                         <#if goodResults?? && (goodResults?size > 0)>
                            <tr >
                              <th colspan="2">产a品名称</th>
                              <th>占比</th>
                              <th>牌面数</th>
                              <th>货架位置</th>
                              <th>sku面积</th>
                            </tr>
                         <#list goodResults as goodResult>
                           <#if goodResult.isShow>
                            <tr>
                              <td colspan="2">${goodResult.goods_desc}</td>
                              <td>${goodResult.ratio}</td>
                              <td>${goodResult.num}</td>
                              <td>${goodResult.rows!""}</td>
                              <td>${goodResult.ori_area!0}</td>
                            </tr>
                           </#if>
                         </#list>
                         </#if>
                       </tbody>
                   </table>
               </h4>
           </li>
       </ul>
   </div>
  <div class="modal fade" id="preview_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog modal-lg" role="document">
           <div class="modal-content content_width">
               <div class="modal-header model_head">
                   <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
               </div>
               <div class="modal-body preview_box">
                   <div class="box-header">
                       <h4 class="box-title ">
                           <#if images?? && (images?size > 0)>共<span>${images?size}</span>张图片<span>（注：单击图片进入标注页面）</span></#if>  
                       </h4>
                        <div class="pull-right" style="margin-top: 10px;">
                               <button id="saveOrder" type="button" class="btn btn-success">保存顺序</button>
                        </div>
                       <form style="padding:0px;margin-top: 31px;" onsubmit="return false;" class="box-body">
                           <ul id="imageList" class="preview_img">
                     			
                           </ul>
                       </form>
                   </div>
               </div>
           </div>
       </div>
   </div>

   <div class="modal fade" id="merge-pre_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog" role="document">
           <div class="modal-content">
               <div class="modal-header model_head">
                   <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
               </div>
               <div class="modal-body">
                   <input type="checkbox" id="is_need_stitch">
                   <span>勾选取消去重</span><br><span>货物类型</span>
                   <select id="majorType" name="majorType">
                       <option value="">请选择一个类型</option>
                        <#if majorTypes?? && (majorTypes?size > 0)>
                         <#list majorTypes as majorType>
                            <option value="${majorType.name}">${majorType.description}${majorType.version!""}</option>
                         </#list>
                         </#if>
                   </select><br>
                   <button id="merge" type="button" style="margin: 5px 0px;" class="btn btn-success">继续拼接</button>
               </div>
           </div>
       </div>
   </div>
   
   <div class="modal fade" id="waiting" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog" role="document">
           <div class="modal-content">
               <div class="modal-header model_head">
                   <h4 id="waitingLabel" style="text-align: center" class="modal-title">正在进行中，客官请稍后...</h4>
               </div>
               <div class="modal-body">
                   <img src="${springMacroRequestContext.contextPath}/image/searchwait.gif" style="margin:0px 0 0 230px"/>
               </div>
           </div>
       </div>
   </div>
   
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/new_list.js"></script>
<script type="text/javascript">
	$(function() {
		newList._init();
	});
</script>