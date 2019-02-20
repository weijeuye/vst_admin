<html>
   <head>
  </head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
					<td colspan="3" width="100">费用包含：</td>
					<input type="hidden" name="suppGoodsId" value=${suppGoodsDesc.suppGoodsId}>
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>费用包含：</td>
					<td colspan=2>
						<textarea class="textWidth" maxlength="2000"  id="priceIncludes" name="priceIncludes" style="width:419px; height:70px" required>${suppGoodsDesc.priceIncludes}</textarea>&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td colspan="3" width="100">费用不包含：</td>
				</tr>
				<tr>
				   <td class="p_label vt w85 ">
						<p>费用不包含:</p>
                   </td>
                  <td colspan=2><input type="text"   placeholder="请填写费用不包含相关信息" class="form-control w582 mr10" style="width: 500px" name="costsNotIncluded" value=<#if suppGoodsDesc?? && suppGoodsDesc.costsNotIncluded??>"${suppGoodsDesc.costsNotIncluded}"</#if>></td>
				</tr>
				<tr>
					<td colspan=3>入园须知：</td>
				</tr>
				<tr>
					<td class="p_label">取票时间：</td>
					<td colspan=2>
						<input   maxlength="100" id="changeTime" type="text" name="changeTime" value="${suppGoodsDesc.changeTime}" style="width:300px; height:25px">
					</td>
				</tr>
				<tr>
					<td class="p_label">取票地点：</td>
					<td colspan=2>
					<table class="p_table form-inline">
						  <tr>
						    <td>
							   <input  maxlength="100" type="text" name="changeAddress" id="changeAddress" value="${suppGoodsDesc.changeAddress}" style="width:300px; height:25px">
						    </td>
						    <td>取票地图上传:</td>
						    <td  rowspan = "2">
						    	<input type="hidden" name="mapImgUrl" value=${suppGoodsDesc.mapImgUrl}>
						    	<img id="mapImg" src="${suppGoodsDesc.mapImgUrl}" height="90" width="90">
						    </td>
						    <td>
							    <div class="mb10">
		                            <a href="javascript:void(0)" class="btn btn_cc1" onclick="uploadImg()" style="width: 60px;height:15px;">上传图片</a>
		                        </div>
						    </td>
						  </tr>
						  
						  <tr>
						    <td></td>
						    <td></td>
						    <td>
							    <div class="mb10">
		                             <a href="javascript:void(0)" class="btn btn_cc1" onclick="deleteImg()" style="width: 60px;height:15px;">删除图片</a>
		                        </div>
						    </td>
						  </tr>
						</table> 	
					</td>
				</tr>
				
				<tr>
					<td class="p_label">入园方式：</td>
					<td colspan=2>
						<input  maxlength="100" type="text" name="enterStyle" id="enterStyle" value="${suppGoodsDesc.enterStyle}" style="width:300px; height:25px"></td>
				</tr>               
				<tr>
					<td class="p_label">有效期：</td>
					<td colspan=2>
						<#if suppGoodsExp?? && suppGoods??>
							<#if suppGoods.aperiodicFlag=='Y'>
								&nbsp;${suppGoodsExp.startTime?string('yyyy-MM-dd')}&nbsp;至&nbsp;${suppGoodsExp.endTime?string('yyyy-MM-dd')}&nbsp;有效<#if suppGoodsExp.unvalidDesc?? >，期票商品不适用日期：${suppGoodsExp.unvalidDesc}</#if>
							<#else>
								指定游玩日${suppGoodsExp.days}天内有效
							</#if>				
						</#if>
						
					</td>
				</tr>
				
			   <tr>
					<td class="p_label"><i class="cc1">*</i>入园限制：</td>
					<td>
						<#if suppGoodsDesc.limitFlag==1>
							<input id='wx' type="radio" name="limitFlag" value="1" checked="checked">无限制</br>
							<input type="radio" name="limitFlag" value="0" id='yx'>有限制&nbsp;&nbsp;&nbsp;							
						<#elseif suppGoodsDesc.limitFlag==0>
							<input id='wx' type="radio" name="limitFlag" value="1">无限制</br>
							<input type="radio" name="limitFlag" value="0" checked="checked" id='yx'>有限制&nbsp;&nbsp;&nbsp;							
						<#else>
							<input id='wx' type="radio" name="limitFlag" checked="checked" value="1">无限制</br>
							<input type="radio" name="limitFlag" value="0" id='yx'>有限制&nbsp;&nbsp;&nbsp;								
						</#if>
						 请在入园当天的
							<select class="w10 mr10" style="width:60px;font-size=1px"  name="hour" id="hour">
							 <#list hourList as item>
							 	<#if item==hour>
							   		<option value="${item}" selected="selected">${item}</option>
							   	<#else>
							   		<option value="${item}">${item}</option>
							   	</#if>
							  </#list>
							</select>
						  点
						  <select class="w10 mr10" style="width:60px" name="minute"  id="minute">								   	
							   <#list minuteList as item>									   
							 	<#if item==minute>
							   		<option value="${item}" selected="selected">${item}</option>
							   	<#else>
							   		<option value="${item}">${item}</option>
							   	</#if>
							  </#list>
						  </select>
						  分以前入园
					</td>
			   </tr>
			   <!--通关时间限制-->
			  <tr>
                    <td class="p_label"><i class="cc1">*</i>通关时间限制：</td>
                    <td>
                        <input type="hidden"  id="passLimitTime" name="passLimitTime"  value ="" />
                        <#if suppGoodsDesc.passFlag=="N">
                            <input id='passLimitWx' type="radio" name="passFlag" value="N" checked="checked">无限制</br>
                            <input type="radio" name="passFlag" value="Y" id='passLimitYx'>下单后&nbsp;&nbsp;&nbsp;                            
                        <#elseif suppGoodsDesc.passFlag=="Y">
                            <input id='passLimitWx' type="radio" name="passFlag" value="N">无限制</br>
                            <input type="radio" name="passFlag" value="Y" <#assign HAS_PASS_LIMIT=true/> checked="checked" id='passLimitYx'>下单后&nbsp;&nbsp;&nbsp;                          
                        <#else>
                            <input id='passLimitWx' type="radio" name="passFlag" checked="checked" value="N">无限制</br>
                            <input type="radio" name="passFlag" value="Y" id='passLimitYx'>下单后&nbsp;&nbsp;&nbsp;                                
                        </#if>
                        <#if HAS_PASS_LIMIT>
                             <input type="text" maxlength="2" style="width:30px; " id="passTimeLimitHour" name="passTimeLimitHour" value ="<#if passTimeLimitHour?? && passTimeLimitHour != "">${passTimeLimitHour}<#else></#if>" />:<#t>
                             <input type="text" maxlength="2"  style="width:30px; " id="passTimeLimitMinute" name="passTimeLimitMinute" value="<#if passTimeLimitMinute?? && passTimeLimitMinute != "">${passTimeLimitMinute}<#else></#if>"/>:<#t>
                             <input type="text" maxlength="2"   style="width:30px; " id="passTimeLimitSeconds" name="passTimeLimitSeconds" value="<#if passTimeLimitSeconds && passTimeLimitSeconds != "">${passTimeLimitSeconds}<#else></#if>"/><#t>后可通关
                        <#else>
                             <input type="text" maxlength="2" style="width:30px; " id="passTimeLimitHour" name="passTimeLimitHour"  disabled="disabled" value ="" /> : <#t>
                             <input type="text" maxlength="2" style="width:30px; " id="passTimeLimitMinute" name="passTimeLimitMinute" disabled="disabled" value=""/> : <#t>
                             <input type="text" maxlength="2" style="width:30px; " id="passTimeLimitSeconds" name="passTimeLimitSeconds" disabled="disabled" value=""/> <#t>后可通关
                         </#if>
                    </td>
               </tr>
			   <tr>
					<td colspan=3>重要提示：</td>
				</tr>
				<tr>
					<td class="p_label">退改说明：</td>
					<td colspan=2>
						${cancelStrategyDesc}
					</td>
				</tr>
				<tr>
					<td rowspan="7" class="p_label">票种说明：</td>
					
				</tr>
				<tr align="right">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身高:<input  maxlength="100" type="text" name="height" value="${suppGoodsDesc.height}" style=" width:300px; height:25px">
				</tr>
				<tr align="right">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年龄:<input maxlength="100" type="text" name="age" value="${suppGoodsDesc.age}" style="width:300px; height:25px">
				</tr>
				<tr align="right">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;地域:<input maxlength="100" type="text" name="region" value="${suppGoodsDesc.region}" style="width:300px; height:25px">
				</tr>
				<tr align="right">
					<td>最大限购:<input maxlength="100" type="text" name="maxQuantity" value="${suppGoodsDesc.maxQuantity}" style="width:300px; height:25px">
				</tr>
				<tr align="right">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;快递:<input maxlength="100" type="text" name="express" value="${suppGoodsDesc.express}" style="width:300px; height:25px">
				</tr>
				<tr align="right">
					<td>实体票:&nbsp;&nbsp;
					  <input maxlength="100" type="text" name="entityTicket" value="${suppGoodsDesc.entityTicket}" style="width:300px; height:25px">
					</td>
				</tr>
				<tr>
					<td>
						其他:
					</td>
					<td>
					<textarea class="textWidth" maxlength="500"  id="others" name="others" style="width:350px; height:70px">${suppGoodsDesc.others}</textarea>&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td>
						描述:
					</td>
					<td>
					<textarea class="textWidth" maxlength="2000"  id="describe" name="describe" style="width:450px; height:100px">${suppGoodsDesc.describe}</textarea>&nbsp;&nbsp;
					<br><span>仅供国内BU使用</span>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
<div class="p_box box_info clearfix mb20">
            <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="saveDesc">保存</a></div>
</div>
</body>
</html>
	<script>
		$(function(){
		isView();

			$(".textWidth[maxlength]").each(function(){
				var	maxlen = $(this).attr("maxlength");
				if(maxlen != null && maxlen != ''){
					var l = maxlen*12;
					if(l >= 500) {
						l = 500;
					} else if (l <= 200){
						l = 200;
					} else {
						l = 400;
					}
					$(this).width(l);
				}
				$(this).keyup(function() {
					vst_util.countLenth($(this));
				});
			});		
			
			if($("#wx").attr("checked")=='checked'){
			  $("#minute").attr("disabled","true");
			  $("#hour").attr("disabled","true");
			}
			 $("#wx").click(function(){
			 	 $("#minute").attr("disabled","true");
			  	 $("#hour").attr("disabled","true");
			 })
			 
			 $("#yx").click(function(){
			     $("#minute").removeAttr("disabled");
			  	 $("#hour").removeAttr("disabled");			 
			 })
			 
			 $("input[name='passFlag']").click(function(){
			    $("#passLimitTime").val("");
                var passLimitVal= $("input[name='passFlag']:checked").val();
                if(passLimitVal=="Y"){
                    $("#passTimeLimitHour").attr("disabled",false);
                    $("#passTimeLimitMinute").attr("disabled",false);
                    $("#passTimeLimitSeconds").attr("disabled",false);
                }else{
                    $("#passTimeLimitHour").attr("disabled",true);
                    $("#passTimeLimitMinute").attr("disabled",true);
                    $("#passTimeLimitSeconds").attr("disabled",true);
                    $("#passTimeLimitHour").val("");
                    $("#passTimeLimitMinute").val("");
                    $("#passTimeLimitSeconds").val("");
                }
             })
             
		})
		
		//上传地图图片
		function uploadImg(){
			var mapImgUrl = $("input[name=mapImgUrl]").val();
			if(null != mapImgUrl && "" != mapImgUrl){
				alert("请保证一个商品只绑定一个图片");
				return;
			}
			var url = "/pic/photo/photo/imgPlugIn.do";
    		url += "?relationId=${suppGoodsDesc.suppGoodsId!''}&relationType=1";
    		if("${imgLimitType!'' }" != '') {
    			url += "&imgLimitType=${imgLimitType!''}"
    		}
    		//设置图片尺寸表示为1
    		photoRatio = 1;
    		comPhotoAddDialog = new xDialog(url,{},{title:"上传图片",iframe:true,width:920,height:750});
		}
		
		//删除地图图片
		function deleteImg(){
		 if(confirm("确定删除取票地图上传？")){
			$("#mapImg").attr("src",null);
	        $("input[name=mapImgUrl]").val(null);
		 }
		}
		
		function validatePassTime(){
           var passLimitVal= $("input[name='passFlag']:checked").val();
          if(passLimitVal=="Y"){
            var passTime=$("#passTimeLimitHour").val()+":"+$("#passTimeLimitMinute").val()+":"+$("#passTimeLimitSeconds").val();
            var re = /^([01][0-9]|2[0-3])\:[0-5][0-9]\:[0-5][0-9]$/;
            if(!re.test(passTime)){
                 return false;
            }else{
             $("#passLimitTime").val(passTime);
             return true;
            }
          }else{
             return true;
          }
        }
		$("#saveDesc").bind('click',function(){
			if(!$("#.dialog #dataForm").validate({
				rules : {
					priceIncludes : {
					}					
				},
				messages : {
					featureDesc : '不可输入特殊字符'
				}
			}).form()){
				$(this).removeAttr("disabled");
				return false;
			}
			//通关时间格式校验
            if(!validatePassTime()){
                alert("通关限制时间格式错误,正确格式如：08:00:00");
                return false;
            }
			var msg = '确认保存吗 ？';	
			if(refreshSensitiveWord($("#dataForm").find("input[type='text'],textarea"))){
			 	msg = '内容含有敏感词,是否继续?'
			}			
			
			$.confirm(msg,function(){
				$.ajax({
					url : "/vst_admin/ticket/goods/goods/suppGoodsDescAdd.do",
					type : "post",
					data : $(".dialog #dataForm").serialize(),
					success : function(result) {
						alert(result.message);
					}
				});
			});
		});
		refreshSensitiveWord($("#dataForm").find("input[type='text'],textarea"));
		
		function photoCallback(photoJson, extJson) {
	        var imgUrl = "";
	        if (photoJson.photos) {
	            imgUrl = "http://pic.lvmama.com" + photoJson.photos[0].photoUpdateUrl;
	        }
	        if (photoJson.photo) {
	            imgUrl = "http://pic.lvmama.com" + photoJson.photo.photoUpdateUrl;
	        }
	        $("#mapImg").attr("src",imgUrl);
	        $("input[name=mapImgUrl]").val(imgUrl);
	        comPhotoAddDialog.close();
	    }
	</script>