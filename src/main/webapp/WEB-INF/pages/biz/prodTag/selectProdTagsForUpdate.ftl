<#--页眉-->
<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
<div class="p_box" id="tagResultList">
 		<table class="p_table table_center" style="margin-top: 10px;">
                <tr>
					<th>小组名称</th>
                    <th>标签名称</th>
                    <th>二级名称</th>
                    <th>起始时间</th>
                    <th>结束时间</th>
                    <th>展示位置</th>
                    <th>操作</th>
	            </tr>
		    	<#if prodTagVOs?? &&  prodTagVOs?size &gt; 0>
					<#list prodTagVOs as item> 
						<tr>
							<td><input type="hidden" name="prodTags.reId" value="${item.reId}">
								<input type="hidden" name="prodTags.objectType" value="${item.objectType}">${item.tagGroup}</td>
							
							<td>${item.tag.tagName}<input type="hidden" name="prodTags.tagName" value="${item.tagName}">
								<input type="hidden" name="prodTags.objectId" value="${item.objectId}">
							</td>
							<td>${item.tag.secondaryTagName}</td>
							<td>
								<input type="text" name="prodTags.startTime" errorEle="code" class="Wdate" id="startDate_${item.reId}" 
								onFocus="WdatePicker({readOnly:true,maxDate:'#F{$dp.$D(\'endDate_${item.reId}\',{d:0});}'})" required 
								value="<#if item.startTime??>${item.startTime?string('yyyy-MM-dd')}</#if>"/>
							</td>
							<td>
								<input type="text" name="prodTags.endTime" errorEle="code" class="Wdate" id="endDate_${item.reId}" 
								onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'startDate_${item.reId}\',{y:2});}',readOnly:true, startDate:'%y-%M-%d 00:00:00', 
								minDate:'#F{getMinDate($dp.$D(\'startDate_${item.reId}\'))}'})" required 
								value="<#if item.endTime??>${item.endTime?string('yyyy-MM-dd')}</#if>"/>							
							</td>
							<td class="ckGoup">
								<input type="hidden" name="prodTags.displaytype" value="${item.displaytype}">
								<input type="checkbox" value="PC端" <#if item.displaytype==1>checked="checked"</#if><#if item.displaytype==3>checked="checked"</#if>/>PC端
								<input type="checkbox" value="无线端" style="margin-left:30px" <#if item.displaytype==2>checked="checked"</#if> <#if item.displaytype==3>checked="checked"</#if>/>无线端
							</td>
							<td>
								<a href="javascript:void(0);" class="delProdTag" data="${item.reId}">删除</a>
							</td>								
						</tr>
					</#list>
			    </#if>
			   <tr>
					<td colspan=6>
						<#if prodTagVOs?? &&  prodTagVOs?size &gt; 0>
							<a class="btn btn_cc1" id="saveTimes">保存</a>
						</#if>
						<a class="btn btn_cc1" id="cancel">关闭</a>
					</td>
			   </tr>				    
	        </table>
	        
</div>

<script>
		   // 创建表单元素
	   function createItem(name,value){
     	   $("#saveDataForm").append('<input type=hidden name='+name+' value='+value+'>');
	   }
	   
	   function getMinDate(date) {
	   
	   	var now = new Date(), year = now.getFullYear();
        var month= now.getMonth()+1;
        var day= now.getDate();
        if(month < 10){
            month = "0" + month;
        }

        if(day<10){
            day = "0" + day;
        }
        var returnDateStr = year + "-" + month + "-" + day;
		var tempMinDate = $dp.$DV(returnDateStr);
		var returnDate = date.compareWith(tempMinDate) <= -1 ? tempMinDate : date;

		return returnDate.y + "/" + returnDate.M + "/" + returnDate.d;
	   }
	   
		$(function(){
			//修改
			$('#saveTimes').bind('click',function(){
				var flag = false;
				
				$(".ckGoup").each(function(){
					var ck1 = $(this).find(":checkbox").eq(0);
					var ck2 = $(this).find(":checkbox").eq(1);
					var txt = $(this).find(":hidden").eq(0);
					
					$(txt).val('');
					if($(ck1).is(':checked') && !$(ck2).is(':checked')){
			 			$(txt).val(1);
				 	}
				 	if(!$(ck1).is(':checked') && $(ck2).is(':checked')){
				 		$(txt).val(2);
				 	}
				 	if($(ck1).is(':checked') && $(ck2).is(':checked')){
				 		$(txt).val(3);
				 	}
				})
				
			    $("input[name='prodTags.displaytype']").each(function(i){
			 	    var value = $(this).val();
    				if(value ==''){
    					flag = true;
			 	    }
			    });
			    
			    $("input[name='prodTags.startTime']").each(function(i){
			 	    var value = $(this).val();
			 	   	if(value ==''){
   						flag = true;
			 	    }
			    });
			    
			    $("input[name='prodTags.endTime']").each(function(i){
			 	    var value = $(this).val();
			 	   	if(value ==''){
   						flag = true;
			 	    }
			    });
			    
			    if(flag == true){
			    	$.alert("修改信息不能为空");
			    } else {
				
					var url = '/vst_admin/biz/prodTag/saveUpdateProdTag.do';
					var msg = '确定修改';
					
					// 清空表单
					$('#saveDataForm').empty();
	
				 	$("input[name='prodTags.reId']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].reId',value);
				    });
				    
				    $("input[name='prodTags.objectType']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].objectType',value);
				    });
				    
				    $("input[name='prodTags.tagName']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].tagName',value);
				    });
				    
				    $("input[name='prodTags.objectId']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].objectId',value);
				    });
				    
				    $("input[name='prodTags.startTime']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].startTime',value);
				    });
				    
				    $("input[name='prodTags.endTime']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].endTime',value);
				    });
				    
				    $("input[name='prodTags.displaytype']").each(function(i){
				 	    var value = $(this).val();
					    createItem('prodTags['+ i +'].displaytype',value);
				    });
				    
					$.confirm(msg,function(){
						$.ajax({
							url : url,
							type : "post",
							data : $("#saveDataForm").serialize(),
							success : function(result) {
								if(result.code=='success'){									
						 	 	 	 $.alert(result.message,function(){
						 	 	 	 	search();
						   				updateDialog.close();	
						 	 	 	 });
						 	 	 }else{
									$.alert(result.message);			 	 	 
						 	 	 }
							}
						});				
					});
			    }
			});
			
			// 删除
			$('.delProdTag').bind('click',function(){
				
				var msg = '确定删除';
				var reId = $(this).attr('data');
				var tagName = $(this).parent().prev().prev().prev().prev().prev().text();
				
				if(reId==null || tagName=='') {
					return false;
				}
				$.confirm(msg,function(){
					$.ajax({
						url : "/vst_admin/biz/prodTag/deleteProdTagByReId.do",
						type : "post",
						data : {reIds:reId,tagName:tagName},
						success : function(result) {
							if(result.code=='success'){
					 	 	 	 $.alert(result.message,function(){
					   				  updateDialog.reload();
					 	 	 	 });
					 	 	 }else{
								$.alert(result.message);			 	 	 
					 	 	 }
					 	 	
					 	 	 return false;
						}
					});	
				});			
			});
			// 取消
			$('#cancel').bind('click',function(){
				updateDialog.close();
			});
			
			  
		})
	
	
</script>


