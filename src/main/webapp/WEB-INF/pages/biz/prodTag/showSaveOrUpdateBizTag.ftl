<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline" style="height:390px" id="dataTable">
			<tbody>
				<tr>
					<input type="hidden" id="tagId" name="tagId" value=<#if bizTag??>${bizTag.tagId}</#if>>
					<input id="updateTime" type="hidden" name="updateTime" value="<#if bizTag?? && bizTag.updateTime??>${bizTag.updateTime?string('yyyy-MM-dd HH:mm:ss')}</#if>">
					<td class="p_label" width="100px;"><i class="cc1">*</i>小组名称：</td>
                	<td colspan=2>
                		<div id="showTagGroup" style="display:block" class="divTagGroup">
	                		<select id="tagGroup" name="tagGroupId" required>
							  	<option value="">请选择</option>
							  	<#if tagGroups?? && tagGroups?size gt 0>
		                    		<#list tagGroups as tagGroup>
		                    			<option value="${tagGroup.tagGroupId}" <#if bizTag?? && (bizTag.tagGroupId == tagGroup.tagGroupId)>selected</#if>>
		                    				${tagGroup.tagGroupName}
		                    			</option>
		                    		</#list>
	                    		</#if>
		                	</select>
                	   </div>	          	   
                	</td>
                	
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>标签名称：</td>
					<td>
            			<input maxlength="20" name="tagName" required="true" type="text" id="tagName" value="<#if bizTag??>${bizTag.tagName}</#if>"/>&nbsp;
            			<a href="javascript:void(0)" class="editTextMultiLang">${bizTagNameMultiLangLinkText}</a>
            			<input type="hidden" id="messageId" name="messageId" value=<#if bizTag??>${bizTag.messageId}</#if>>
					</td>&nbsp;&nbsp;
					<td>
						二级名称：
            			<input maxlength="20" name="secondaryTagName"  type="text" id="secondaryTagName" value="<#if bizTag??>${bizTag.secondaryTagName}</#if>"/>
					</td>
				</tr>
				
				<tr>
					<td class="p_label"><i class="cc1">*</i>标签拼音：</td>
					<td colspan=2>
            			<input maxlength="40" id="pinyin" type="text" name="pinyin"  readonly = "readonly" value="<#if bizTag??>${bizTag.pinyin}</#if>"/>
					</td>
					
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>SEQ：</td>
					<td colspan=2>
						<input id="seq" type="text" name="seq" value="<#if bizTag??>${bizTag.seq}</#if>">
					</td>
					
				</tr>			
			   <tr>
					<td class="p_label">标签描述：</td>
					<td colspan=2>
						<textarea class="w35 textWidth" style="width: 700px; height: 80px;" id="memo" name="memo" maxlength="240"><#if bizTag??>${bizTag.memo}</#if></textarea>
						&nbsp;<a href="javascript:void(0)" class="editTagNameMemoMultiLang">${bizTagMemoMultiLangLinkText}</a>
						<input type="hidden" id="memoMessageId" name="memoMessageId" value=<#if bizTag??>${bizTag.memoMessageId}</#if>>
					</td>
					
			   </tr>
			   <tr>
			   		<td class="p_label"><i class="cc1">*</i>标签状态：</td>
					<td>
                        <label class="radio mr10">
                        	<input type="radio" name="cancelFlag" value='Y' required=true <#if bizTag==null || bizTag.cancelFlag ="Y"> checked</#if> >有效
                        </label>
                        <label class="radio mr10">
                        	<input type="radio" name="cancelFlag" value='N' required=true <#if bizTag?? && bizTag.cancelFlag ="N"> checked</#if> >无效	
                        </label>
                    </td> 
			   </tr>
			   <tr>
			   		<td class="p_label">标签到期时间：</td>
					<td>
                        <input type="text" id="expirationTime" name="expirationTime" errorEle="code" class="Wdate" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}'})"  
                        	value="<#if bizTag?? && bizTag.expirationTime??>${bizTag.expirationTime?string('yyyy-MM-dd')}</#if>"/>
                    </td>
			   </tr>
			   <tr>
			   		<td class="p_label"><i class="cc1">*</i>标签类型：</td>
					<td>
                        <label class="radio mr10">
                        	<input type="radio" name="tagType" id="tagType_0"  value='0' <#if bizTag==null || bizTag.tagType=0> checked</#if>>普通标签
                        </label>
                        <label class="radio mr10">
                        	<input type="radio" name="tagType" id="tagType_1"  value='1' <#if bizTag?? && bizTag.tagType=1> checked</#if>>大促标签	
                        </label>
                    </td>
                    
			   </tr>
			   
			  
			   	<tr>
			   		<td class="p_label"><i class="cc1">*</i>关联品类：</td>
					<td>
						<input type="checkbox" name="categoryIds" value="0" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(0)>checked="checked"</#if>>全部旅游</input>
                        <input type="checkbox" name="categoryIds" value="5" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(5)>checked="checked"</#if>>门票</input>
                        <input type="checkbox" name="categoryIds" value="15" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(15)>checked="checked"</#if>>跟团游</input>
                        <input type="checkbox" name="categoryIds" value="18" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(18)>checked="checked"</#if>>自由行</input>
                        <input type="checkbox" name="categoryIds" value="2" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(2)>checked="checked"</#if>>邮轮</input>
                        <input type="checkbox" name="categoryIds" value="16" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(16)>checked="checked"</#if>>当地游</input>
                        <input type="checkbox" name="categoryIds" value="30" <#if bizTag?? &&  bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(30)>checked="checked"</#if>>当地玩乐</input>
                        <input type="checkbox" name="categoryIds" value="181" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(181)>checked="checked"</#if>>景+酒</input>
                        <input type="checkbox" name="categoryIds" value="4" <#if bizTag?? && bizTag.categoryIdList?? && bizTag.categoryIdList?seq_contains(4)>checked="checked"</#if>>签证</input>
                    </td>
                    
			   	</tr>
			   		
			   	<tr>
			   		<td class="p_label"><i class="cc1">*</i>大促时间：</td>
					<td>
                        <input type="text" id="startTime" name="startTime" errorEle="code" class="Wdate" onFocus="WdatePicker({readOnly:true})"  
                        	value="<#if bizTag?? && bizTag.startTime??>${bizTag.startTime?string('yyyy-MM-dd')}</#if>"/> - 
						<input type="text" id="endTime" errorEle="code" class="Wdate" name="endTime" onFocus="WdatePicker({readOnly:true, minDate:'#F{$dp.$D(\'startTime\',{d:0});}'})"  
							value="<#if bizTag?? && bizTag.endTime??>${bizTag.endTime?string('yyyy-MM-dd')}</#if>"/> &nbsp;
                    </td>
			   	</tr>
			   		
			   		
			   	<tr>
			   		<td class="p_label">图片设置：</td>
			   		<td>
			   		 	<input type="hidden" name="imageURL" id="imageURLText" value="<#if bizTag??>${bizTag.imageURL}</#if>"/>
						<#if bizTag?? && bizTag.imageURL!=null && bizTag.imageURL!=''>
							<li class="removeImg" id="image">
                        	<img src="http://pic.lvmama.com${bizTag.imageURL}" width="80" height="40"  class='picImg32'  id="imageURL"/>&nbsp;删除图片 
		        			</li>
		        		<#else>
		        			<li class="addImg" id="image">
		            	 	+图片 
		        			</li>
		        		</#if>
                    </td>
			   	</tr>
			   	
			 
			   		   
			</tbody>
		</table>
		
		<table class="p_table form-inline" style="height:30px">
			<tbody>
				<tr>
					<td class="p_label">&nbsp;</td>
					<td colspan=2>
						<a class="btn btn_cc1" id="saveOrUpdate">提交</a>
						<a class="btn btn_cc1" id="cancel">取消</a>
					</td>
			   </tr>			   
			</tbody>
		</table>
	</form>
<#include "/base/foot.ftl"/>
</body>
</html>
	<script>
		var comPhotoAddDialog = null;
		var multiLangDialog = null;
		
		$(function() {
			
			$(".textWidth[maxlength]").each(function() {
				var	maxlen = $(this).attr("maxlength");
				if(maxlen != null && maxlen != ''){
					var l = maxlen*12;
					if(l >= 700) {
						l = 500;
					} else if (l <= 200){
						l = 200;
					} else {
						l = 200;
					}
					$(this).width(l);
				}
				$(this).keyup(function() {
					vst_util.countLenth($(this));
				});
			});	
			
			if($('input[type=radio][name=tagType]:checked').val()!='1') {
				$('#dataTable tbody tr:gt(7)').attr('style','display:none');
			}
			
			$('input[type=radio][name=tagType]').bind('click',function() {
				var value = this.value;
				if(value=='0') {
					$('#dataTable tbody tr:gt(7)').attr('style','display:none');
				} else {
					$('#dataTable tbody tr:gt(7)').attr('style','');
				}				  
			});
			
    		
    		$('#image').bind("click", function() {
    		
    			var attr = this.getAttribute("class");
    			if(attr=='addImg') {
    				var url = "/photo-back/photo/photo/imgPlugIn.do";
    				comPhotoAddDialog = new xDialog(url,{},{title:"上传图片",iframe:true,width:1000,height:800,scrolling:"yes"});
    			} else if(attr=='removeImg') {
    				$('#imageURLText').val('');
    				$(this).find('img').remove();
    				this.innerText="+图片";
    				this.setAttribute('class','addImg');
    			}
    		});
    		
    		
    		// 跳转到标签名多语言配置页面
			$(".editTextMultiLang").bind("click",function() {
				
				var messageId = $('#messageId').val();
				var url = "/vst_admin/biz/bizTag/setBizTagMultiLang.do?messageId=" + messageId;
				multiLangDialog = new xDialog(url,{},{title:"多语言配置",iframe:true,width:800,height:700});
				return false;
			});	
			
			// 跳转到标签简介多语言配置页面
			$(".editTagNameMemoMultiLang").bind("click",function() {
				
				var messageId = $('#memoMessageId').val();
				var url = "/vst_admin/biz/bizTag/setBizTagMemoMultiLang.do?messageId=" + messageId;
				multiLangDialog = new xDialog(url,{},{title:"多语言配置",iframe:true,width:1000,height:900});
				return false;
			});
			
			/**
			 * 验证整数或验证非零的负整数
			 */
			jQuery.validator.addMethod("isMinus1", function(value, element) {
			    var chars =  /^[0-9]\d*$/;// 验证正整数  
			    var rq =  /^\-[1-9][0-9]*$/;// 验证非零的负整数
			    return this.optional(element) || (chars.test(value) || (rq.test(value)));       
			 }, "只能填写整数或非零的负整数");		
			 
			/**
			 * 验证整数或验证非零的负整数
			 */
			jQuery.validator.addMethod("isInteger1", function(value, element) {
			    var chars =  /^[0-9]\d*$/;// 验证正整数  
			    return this.optional(element) || chars.test(value);       
			 }, "只能填写整数");			
		
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
			
			// 隐藏或显示小组名称
			$("input[name=tagGroupName][type=radio]").bind('click',function(){
				if($(this).attr("checked")=='checked'){
					var value = $(this).val();
					$('#showTagName').attr('style','display:none');
					$('#showTagGroup').attr('style','display:block');
					// $("#selectTagName").hide();
					$(".combo-text,.combo").show();
					var n = $('#tagName').val();
					var py = vst_pet_util.convert2pinyin(n);
					$("#pinyin").val(py);
		            $("#tagName").val(n);
					
				}			
			});	
			
			// 新增与修改
			$('#saveOrUpdate').bind('click',function(){
				//验证
				// $("#selectTagName").show();
				if(!$("#dataForm").validate({
					rules : {
						addTagGroup:{
							required : true
						},
						tagGroup:{
							required : true
						},						
						tagName:{
							required : true
						},
						pinyin:{
							required : true
						},
						style:{
							isInteger1 : true
						},
						tagType:{
							isInteger1 : true
						},
						seq:{
							required : true,
							isMinus1 : true
						}
					}
				}).form()){
					
					return false;
				}
				
				var msg = '确定新增';
				var tagId = $('#tagId').val();
				if(tagId.length > 0) {
					msg = '确定修改';				
				}
				
				
			 	
			 	var tagType = $('#tagType_1').attr("checked");
			 	
				if(tagType=='checked') {
					var num = 0; 
					$("input:checkbox[name='categoryIds']:checked").each(function() {
						num=num+1;
					});
					
					if(num==0) {
						$.alert('大促标签的品类是必填项！');
						return false;
					}
					
					var startTime = $('#startTime').val();
					if($.trim(startTime)=='') {
						$.alert('大促标签的起止时间是必填项！');
						return false;
					}
					
					var endTime = $('#endTime').val();
					if($.trim(endTime)=='') {
						$.alert('大促标签的起止时间是必填项！');
						return false;
					}
					
				}
				
				$.confirm(msg,function(){
					$.ajax({
						url : "/vst_admin/biz/bizTag/tagGroupOrNameisExists.do",
						type : "post",
						data : $("#dataForm").serialize(),
						success : function(result) {
							if(result.code=='success'){
								$.ajax({
									url : "/vst_admin/biz/bizTag/saveOrUpdateBizTag.do",
									type : "post",
									data : $("#dataForm").serialize(),
									success : function(result) {
									
									   if(result.code=='success') {
									 	 	 $.alert(result.message,function(){
									   			parent.search();
									   			parent.showAddOrUpdate.close();	
									 	 	 });
								 	   } else {
								 	   		var errorMsg = JSON.parse(result);
											$.alert(errorMsg.message);	 	 
								 	   }
									}
								});						 	 	 	
					 	 	 } else {
								$.alert(result.message);
								return false;			 	 	 
					 	 	 }
						}
					});						
				});
			});
			
			// 取消
			$('#cancel').bind('click',function(){
				parent.showAddOrUpdate.close();	
			});
			
			// 根据标签名称动态生成拼音
			$("#dataForm #tagName").bind("change",function(){ 
				var py = vst_pet_util.convert2pinyin($(this).val());
				$("#pinyin").val(py);
			});	
			
			$('#tagGroup').bind('change',function(){
				$("#selectTagName").val("");
				// findAllTagNameByGroup();
			});
		
			// findAllTagNameByGroup();						
		})
		
		// 根据小组名称查询有效标签
		function findAllTagNameByGroup(){
			$('#tagName').combobox({  
	            url : "/vst_admin/biz/bizTag/findAllTagNameByGroup.do?isAll=Y&iniAll="+encodeURIComponent(encodeURIComponent('请选择'))+"&tagGroup=" + encodeURIComponent(encodeURIComponent($('#tagGroup').val())),
	            valueField:'tagValue',  
	            textField:'tagName',
	            filter: function(q, row){
	                var opts = $(this).combobox('options');
	                return row[opts.textField].match(q);
	            }, 
	            onLoadSuccess:function(){
	            	var tagName = $("#selectTagName").val();
	            	if(tagName != ''){
	            		$('#tagName').combobox('setValue',tagName).combobox('setText',tagName);
	            	}else{
	            		$('#tagName').combobox('setText','请选择');
	            	}
	            }, 
	            onLoadError:function(){
	            	$.alert(result.message);
	            },
	            onChange: function (n,o){
	            	var py = vst_pet_util.convert2pinyin(n);
					$("#pinyin").val(py);
					$("#selectTagName").val(n);
					if(n==''){
	            		$("i[for=selectTagName]").show();
	            	}else{
	            		$("i[for=selectTagName]").hide();
	            	}
	            }       
	     });
	}
	
	function photoCallback(photoJson, extJson) {
	
		var imageUrl;
		if(comPhotoAddDialog != null) {
			comPhotoAddDialog.close();
		}
		
		if(photoJson!=null && photoJson.photos!=null && photoJson.photos.length > 0 && photoJson.photos[0].photoUpdateUrl!='') {
			if(photoJson.photos.length > 1) {
				$.alert('只允许选择1张照片！');
				return false;
			}
			imageUrl = photoJson.photos[0].photoUpdateUrl;
			$('#imageURLText').val(imageUrl);
			$('#image').html("<img src='http://pic.lvmama.com"+ imageUrl + "' width='80' height='40'  class='picImg32' id='imageURL'/>&nbsp; 删除图片");
			$('#image').attr("class", "removeImg");
		} else {
			$.alert('图片资源不存在！');
		}
		
	}
	</script>