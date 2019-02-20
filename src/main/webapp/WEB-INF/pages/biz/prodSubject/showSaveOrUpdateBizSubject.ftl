<!DOCTYPE html>
<html>
<head>
</head>
  <body>
  	<div class="iframe_content mt10">
		<form id="dataForm">
			<table class="p_table form-inline">
				<tbody>
					<tr>
                        <td class="p_label"><i class="cc1">*</i>主题小组：</td>
						<td colspan=2>
							<div id="showSubjectGroup" style="display:block">
								<select id="subjectGroup" name="subjectGroup" required>
									<option value="">请选择</option>
								<#if subjectGroups?? && subjectGroups?size gt 0>
									<#list subjectGroups as sg>
										<#if sg?? && sg.subjectGroup??>
											<option value="${sg.subjectGroup}" <#if bizSubject?? && (bizSubject.subjectGroup == sg.subjectGroup)>selected</#if>>
												${sg.subjectGroup}
											</option>
										</#if>
									</#list>
								</#if>
								</select>
								<span><input type="radio" value="addSubjectGroup" name="subjectGroupName"/>
								<#if bizSubject?? && bizSubject.subjectId??>
									修改小组名称
								<#else>
									新增小组名称
								</#if>
								</span>
							</div>
							<div id="showSubjectName" style="display:none">
								<input type="text" maxlength="20" name="addSubjectGroup" id="addSubjectGroup" required/>
								<span><input type="radio" value="selectSubjectGroup" name="subjectGroupName"/>选择已有小组</span>
							<div>
						</td>
					</tr>
					<tr>
						<input type="hidden" id="subjectId" name="subjectId" value=<#if bizSubject??>${bizSubject.subjectId}</#if>>
						<td class="p_label"><i class="cc1">*</i>主题名称：</td>
						<td colspan=2>
                            <select id="selectSubjectName">
                            </select>
	            			<input maxlength="50" id="subjectName" type="text" name="subjectName" required="true" style="display:none" value="<#if bizSubject??>${bizSubject.subjectName}</#if>"/>
	            			&nbsp;&nbsp;<a href="javascript:void(0)" class="editTextMultiLang">${bizSubjectNameLinkText}</a>
	            			<input type="hidden" id="messageId" name="messageId" value=<#if bizSubject??>${bizSubject.messageId}</#if>>
						</td>
					</tr>
					<tr>
						<td class="p_label"><i class="cc1">*</i>主题拼音：</td>
						<td colspan=2>
	            			<input maxlength="100" id="pinyin" type="text" name="pinyin" value="<#if bizSubject??>${bizSubject.pinyin}</#if>"/>
						</td>
					</tr>
					<tr>
						<td class="p_label"><i class="cc1">*</i>主题类型：</td>
						<td colspan=2>
	                		<#list parentSubjectTypeList as type>
	                			<label>
	                			<input type="radio" errorEle="code" name="parentSubjectType" <#if parentSubjectType?? && (type.code == parentSubjectType)>checked="checked"</#if> value="${type.code}" />
	                			${type.cnName}
	                			</label>
	                		</#list>
	                		<div id="codeError" style="display:inline"></div>						
						</td>
					</tr>
					
					<tr id="childrenSubjectTypes">
						<td class="p_label"><i class="cc1">*</i>子主题类型：</td>
						<td colspan=2 id="childrenSubjectType">
	                		<#list subjectTypeList as type>
	                			<label>
	                			<input type="radio" name="subjectType" errorEle="code" <#if bizSubject?? && (type.code == bizSubject.subjectType)>checked="checked"</#if> value="${type.code}" />
	                			${type.cnName}
	                			</label>
	                		</#list>
	                		<div id="codeError" style="display:inline"></div>						
						</td>
					</tr>								
					<tr>
						<td class="p_label">是否标红：</td>
	                	<td colspan=2>
	                		<select id="redFlag" name="redFlag" required>
							  	<#if bizSubject?? && bizSubject.redFlag=='Y'>
							  		<option value="Y" selected>是</option>
							  		<option value="N">否</option>
							  	<#else>
							  		<option value="Y">是</option>
							  		<option value="N" selected>否</option>						  	
							  	</#if>
		                	</select>
	                	</td>
					</tr>
					<tr>
						<td class="p_label">状态：</td>
						<td colspan=2>
	                		<select id="cancelFlag" name="cancelFlag" required>
							  	<#if bizSubject?? && bizSubject.cancelFlag=='Y'>
							  		<option value="Y" selected>有效</option>
							  		<option value="N">无效</option>
							  	<#else>
							  		<option value="Y">有效</option>
							  		<option value="N" selected>无效</option>						  	
							  	</#if>
		                	</select>					
						</td>
					</tr>
					<tr>
						<td class="p_label">排序值：</td>
						<td colspan=2>
							<input id="seq" type="text" name="seq" value="<#if bizSubject??>${bizSubject.seq}</#if>" />
						</td>
					</tr>				
				   <tr>
						<td class="p_label">引用次数：</td>
						<td colspan=2>
							${count}
						</td>
				   </tr>
				   <tr>
						<td class="p_label">创建时间：</td>
						<td colspan=2>
							<#if bizSubject?? && bizSubject.createTime??>${bizSubject.createTime?string('yyyy-MM-dd HH:mm:ss')!''}</#if>
						</td>
				   </tr>
				   <tr>
						<td class="p_label">更新时间：</td>
						<td colspan=2>
							<#if bizSubject?? && bizSubject.updateTime>
								${bizSubject.updateTime?string('yyyy-MM-dd HH:mm:ss')!''}
							</#if>
						</td>
				   </tr>			   			   
				   <tr>
						<td class="p_label"></td>
						<td colspan=2 align="center">
							<#if bizSubject?? && bizSubject.subjectId>
								<a class="btn btn_cc1 saveOrUpdate">修改</a>
							<#else>
								<a class="btn btn_cc1 saveOrUpdate">新增</a>
							</#if>
							<a class="btn btn_cc1" id="cancel">取消</a>
						</td>
				   </tr>			   
				</tbody>
			</table>
		</form>
	</div>
</body>
</html>
	<script>
		var multiLangDialog;
		
		$(function(){
			//点击小组名称
            $('input[type=radio][name=subjectGroupName]').bind('click',function(){
                if($(this).attr('checked')=='checked'){
                    var value = $(this).val();
                    if(value=='addSubjectGroup'){
                        $('#showSubjectName').attr('style','display:block');
                        $('#showSubjectGroup').attr('style','display:none');
                        $("#subjectName").show();
                        $(".combo-text,.combo").hide();
                    }else{
                        if(value=='selectSubjectGroup'){
                            $('#addSubjectGroup').val('');
                        }
                        $('#showSubjectName').attr('style','display:none');
                        $('#showSubjectGroup').attr('style','display:block');
                        $("#subjectName").hide();
                        $(".combo-text,.combo").show();

                        var n = $('#selectSubjectName').combobox('getValue');
                        var py = vst_pet_util.convert2pinyin(n);
                        $("#pinyin").val(py);
                        $("#subjectName").val(n);
                    }
                }
            });
            
            
            // 跳转到标签名多语言配置页面
			$(".editTextMultiLang").bind("click",function() {
				
				var messageId = $('#messageId').val();
				var url = "/vst_admin/biz/bizSubject/setBizSubjectMultiLang.do?messageId=" + messageId;
				multiLangDialog = new xDialog(url,{},{title:"多语言配置",iframe:true,width:800,height:700});
				return false;
			});	

            var subjectId = $('#subjectId').val();
			
			//新增或修改主题获得子主题类型列表
			if(subjectId.length == 0 ){
			
				$('#childrenSubjectTypes').hide();
				getchildrenSubjectType(subjectId);
				
				}else{
					$('input[name=parentSubjectType]').attr("disabled","true");
				}
				
			// 新增与修改
			$('.saveOrUpdate').bind('click',function(){
				
				/**
				 * 验证整数或验证非零的负整数
				 */
				jQuery.validator.addMethod("isMinus1", function(value, element) {
				    var chars =  /^[0-9]\d*$/;// 验证正整数  
				    var rq =  /^\-[1-9][0-9]*$/;// 验证非零的负整数
				    return this.optional(element) || (chars.test(value) || (rq.test(value)));       
				 }, "只能填写整数或负整数");
				
				//验证
                $("#subjectName").show();
				if(!$("#dataForm").validate({
					rules : {
                        addSubjectGroup:{
                            required : true
                        },
                        subjectGroup:{
                            required : true
                        },
						subjectName:{
							required : true
						},
						pinyin:{
							required : true
						},						
						subjectType:{
							required : true
						},
						seq:{
							isMinus1 : true
						},parentSubjectType:{
							required : true
						}
					}
				}).form()){
                    if($("input[name=subjectGroupName][type=radio]").attr("checked")=='checked'){
                        $("#subjectName").show();
                    }else{
                        $("#subjectName").hide();
                    }
					return false;
				}

                if($("input[name=subjectGroupName][type=radio]").attr("checked")=='checked'){
                    $("#subjectName").show();
                }else{
                    $("#subjectName").hide();
                }
				
				var msg = '确定新增';
				var subjectId = $('#subjectId').val();
				if(subjectId.length>0){
					msg = '确定修改';				
				}
				$.confirm(msg,function(){
					$.ajax({
						url : "/vst_admin/biz/bizSubject/subjectNameOrPyisExists.do",
						type : "post",
						data : $("#dataForm").serialize(),
						success : function(result) {
							if(result.code=='success'){
								$.ajax({
									url : "/vst_admin/biz/bizSubject/saveOrUpdateProdTag.do",
									type : "post",
									data : $("#dataForm").serialize(),
									success : function(result) {
									   if(result.code=='success'){
									 	 	 $.alert(result.message,function(){
									 	 	 	search();
									 	 	 	showAddOrUpdate.close();
									 	 	 });
								 	   }else{
										  	$.alert(result.message);			 	 	 
								 	   }
									}
								});						 	 	 	
					 	 	 }else{
								$.alert(result.message);			 	 	 
					 	 	 }
						}
					});						
				});
			});
			
			// 取消
			$('#cancel').bind('click',function(){
				showAddOrUpdate.close();	
			});
			
			// 根据标签名称动态生成拼音
			$("#dataForm #subjectName").bind("change",function(){
				var py = vst_pet_util.convert2pinyin($(this).val());
				$("#pinyin").val(py);
			});

            $('#subjectGroup').bind('change',function(){
                //$("#subjectName").val("");
                findAllSubjectNameByGroup();
            });

            findAllSubjectNameByGroup();
		})

        // 根据小组名称查询有效主题
        function findAllSubjectNameByGroup() {
            $('#selectSubjectName').combobox({
                url: "/vst_admin/biz/bizSubject/findAllSubjectNameByGroup.do?isAll=Y&iniAll=" + encodeURIComponent(encodeURIComponent('请选择')) + "&subjectGroup=" + encodeURIComponent(encodeURIComponent($('#subjectGroup').val())),
                valueField: 'subjectValue',
                textField: 'subjectName',
                filter: function (q, row) {
                    var opts = $(this).combobox('options');
                    return row[opts.textField].match(q);
                },
                onLoadSuccess: function () {
                    var subjectName = $("#subjectName").val();
                    if (subjectName != '') {
                        $('#selectSubjectName').combobox('setValue', subjectName).combobox('setText', subjectName);
                    } else {
                        $('#selectSubjectName').combobox('setText', '请选择');
                    }
                },
                onLoadError: function () {
                    $.alert(result.message);
                },
                onChange: function (n, o) {
                    var py = vst_pet_util.convert2pinyin(n);
                    $("#pinyin").val(py);
                    $("#subjectName").val(n);
                    if (n == '') {
                        $("i[for=subjectName]").show();
                    } else {
                        $("i[for=subjectName]").hide();
                    }
                }
            });
        }

		function getchildrenSubjectType(){
					$('input[name=parentSubjectType]').bind("click",function(){
					var parentSubjectTypeCode = $('input[name=parentSubjectType]:checked').val();
					var htmlArray =[];
					$.ajax({
						url:"/vst_admin/biz/bizSubject/getSubjectTypeForParentTypeCode.do",
						type:"post",
						data:{"parentSubjectTypeCode":parentSubjectTypeCode},
						success: function(data){
							if(data.length != 0){
								$.each(data,function(i,n){
								 htmlArray.push('<label>');
								htmlArray.push('<input type="radio" errorEle="code" name="subjectType"  value="'+i+'" />');
								htmlArray.push(""+n);
								htmlArray.push('</label>');
								});
								var str = htmlArray.join('');
								$('#childrenSubjectType').html(str);
								$('#childrenSubjectTypes').show();
								
							}
						}
					});
				
				}); 
			
			};
			
		
	</script>