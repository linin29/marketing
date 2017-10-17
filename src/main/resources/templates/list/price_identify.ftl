<style type="text/css">
   body {padding-right:0px !important;}
   img {max-width: 100%;}
</style>
<div class="create_task max_width">
       <ul>
           <li>
               <h4>
                   <img class="img_icorn" src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>选择照片</span>
                   <div class="choose-box-body">
                       <div class="row" style="padding-left: 15px;">
                           <div class="col-xs-1 choose_btn" style="width: 125px;padding-right: 4px;">
                               <span class="btn btn-success btn-sm fileinput-button pull-right">
                                   <img src="${springMacroRequestContext.contextPath}/image/camera_icorn.png" class="st_camera">
                                   <span>上传图片</span>
                                   <input type="button" class="btn btn-success" id="upload_file" value="选择上传的文件" />
								   <input type="file" id="file_select" style="display:none;"/>
                               </span>
                           </div>
                       </div>
                   </div>
               </h4>
           </li>
           <li>
               <h4>
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>商品价格照片</span>
                   <div style="clear:both"></div>                   
                   <div class="row" id="stitch_image">
	                   <div id="image_default"  align="center"  class="col-sm-8">
		                   <img id="preview" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img">
	                   </div>
	               </div>
               </h4>
               <div style="clear:both;"></div>
           </li>
           <li>
               <h4 style="padding-bottom: 28px;">
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>识别数据</span>
                   <table id="countInfo" class="table table-bordered table-hover table-condensed count_table">
                       <thead>
                            <tr>
                            	<th colspan="2">商品名称</th>
                            	<th colspan="2">商品价格</th>
                            </tr>
                       </thead>
                       <tbody>
                            <tr id="priceIdentifyResult">
                              
                            </tr>
                       </tbody>
                   </table>
               </h4>
           </li>
       </ul>
   </div>
   
   <div class="modal fade" id="waiting" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog" role="document">
           <div class="modal-content">
               <div class="modal-header model_head">
                   <h4 id="waitingLabel" style="text-align: center" class="modal-title">正在进行中，请稍后...</h4>
               </div>
               <div class="modal-body">
                   <img src="${springMacroRequestContext.contextPath}/image/searchwait.gif" style="margin:0px 0 0 230px"/>
               </div>
           </div>
       </div>
   </div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/price_identify.js"></script>
<script type="text/javascript">
	$(function() {	
		priceIdentify._init();
	});
</script>