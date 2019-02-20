<!DOCTYPE html>
<html>
<#include "/base/head_meta.ftl"/>
<body>
	
	<div class="iframe_search">		
		<span style="color:grey">提示：产品编号中可输入多个产品ID，ID间用“，”分隔，可同时查询多个产品</span>
		<form method="post" action='/vst_admin/biz/prodTag/findProdTagList.do' id="searchForm">
			<input type="hidden" name="objectType" value="PROD_PRODUCT"/>
			<input type="hidden" id="brandTagGroupId" value="${tagGroups[0].tagGroupId}"/>
	        <table class="s_table">
	            <tbody>
					<tr>
	                	<td class="s_label">小组名称：</td>
	                    <td class="w18">
	                    	<select name="tagGroupId" id="tagGroup">
	                    		<option value="" <#if (prodTagVO.tagGroup==null || prodTagVO.tagGroup=='')>selected</#if>>全部</option>
	                    		<#list tagGroups as tagGroup>
	                    			<option value="${tagGroup.tagGroupId}" <#if (prodTagVO.tagGroupId == tagGroup.tagGroupId)>selected</#if>>
	                    				${tagGroup.tagGroupName}
	                    			</option>
	                    		</#list>
	                    	</select>
	                    </td>
	                 	<td class="s_label">标签名称：</td>
	                    <td class="w18">
	                    	<input type="hidden" id="selectTagName" value="${prodTagVO.tagName}"/>
	                        <select name="tagName" id="tagName" >
	                    		<option value="">全部</option>
				        	</select>
	                    </td>
	                    <td class=" operate mt10">
	                    </td>
	                </tr>   
	                      
					<tr>
		            	<td class="s_label">产品编号：</td>
		                <td class="w18" colspan="4">
		                	<textarea id="productIds" maxlength="4000" class="textWidth" name="productIds" style="height:40px;width:500px;" required>${prodTagVO.productIds}</textarea>
		                </td>
		            </tr>			
					<tr>
		                <td class="s_label">品类：</td>
		                <td class="w18">
		                	<select name="categoryName" id="categoryName">
		                    	<option value="">全部</option>
		                    	<#list bizCategorys as bizCategory>
		                    	<#if bizCategory.categoryId=='6'>
			                    	<option value="${bizCategory.categoryId}" <#if (prodTagVO.categoryName == bizCategory.categoryId)>selected</#if>>
				                				邮轮组合产品
				                	</option>		                    			
		                    	<#else>
			                    	<option value="${bizCategory.categoryId}" <#if (prodTagVO.categoryName == bizCategory.categoryId)>selected</#if>>
				                		${bizCategory.categoryName}
				                	</option>		                    			
		                    	</#if>
		                    	</#list> 
		                    </select>
		                 </td>
		                 	
		                 <td class="s_label">产品名称：</td>
		                 <td class="w18">
		                 	<input style="width:260px;" maxlength="100" id="productName" type="text" name="productName" value="${prodTagVO.productName}"/>
		                 </td>
		                 <td class="operate mt10">
			                 &nbsp;<a class="btn btn_cc1" id="search_button">查询</a> 
		                 </td>
		                 <td class="operate mt10">
		                     &nbsp;
		                 </td>
		              </tr>
		                         
	                              
	            </tbody>
	        </table>	
		</form>
		<#if pageParam??>
	    	<#if pageParam.items?? &&  pageParam.items?size &gt; 0>
				<div style="margin-top: 10px;" class="delProdTag">
					<a class="btn btn_cc1" href="javascript:void(0);" id="addProdTag">批量添加标签</a>
					<a class="btn btn_cc1" href="javascript:void(0);" id="delProdTag">批量删除标签</a>
					<a class="btn btn_cc1" href="javascript:void(0);" id="updateProdTag">批量修改标签</a>
				</div>         	  
				<!-- 主要内容显示区域\\ -->
				<div class="iframe-content">
					<span style="color:grey">提示：全选为选择当前页的所有产品</span>
				    <div class="p_box">
					    <table class="p_table table_center" style="margin-top: 10px;">
		                    <tr>
								<th width="60">&nbsp;<input type="checkbox" class="selectAll"/></th>
								<th width="60">产品ID</th>
				                <th width="300">产品名称</th>
				                <th width="60">标签操作</th>
		                    </tr>
							<#list pageParam.items as item> 
								<tr>
										<td><input type="checkbox" value="${item.productId}" name="objectIds"/></td>
										<td>${item.productId}</td>
										<td>${item.productName}</td>
										<td>
											<a href="javascript:void(0);" class="add" data="${item.productId}" data1="${item.productName}">新增</a>										
											<a href="javascript:void(0);" data="${item.productId}" data1="${item.productName}" class="update">修改</a>										
											<a href="javascript:void(0);" class="showLogDialog"
											   param='parentId=${item.productId}&parentType=PROD_TAG_SUBJECT&sysName=VST'>操作日志</a>
										</td>
								</tr>
							</#list>
       				 	</table>
				    </div><!-- div p_box -->
				</div>
				<!-- //主要内容显示区域 -->
				<#if pageParam.items?exists> 
					<div class="paging" > 
						${pageParam.getPagination()}
					</div> 
				</#if>
			<#else>
				<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
			</#if>
		</#if>		
    </div>
         
	
	<form id="selectTagNameForm">
	</form>	
	<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	
	
	   // 创建表单元素
   function createItem(name,value){
 	   $("#selectTagNameForm").append('<input type=hidden name='+name+' value='+value+'>');
   }

	var updateDialog,addDialog,delDialog,setSeqDialog;
	
	var brandTagGroupId;
	
	$(function(){
		brandTagGroupId = $('#brandTagGroupId').val();
		
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
	
				
		
		// 查询
		$('#search_button').bind('click',function() {
			search();
		});
		
		
		// 批量添加标签
		$('#addProdTag').bind('click',function() {
			var size = $("input[type=checkbox][name=objectIds]:checked").size();
			if(size<=0){
				$.alert('请选择添加标签的产品');
				return false;
			}else{
				var objectType= $('#objectType').val();
				var tagGroup= $('#tagGroup').val();
				var title = '批量添加标签';
				addDialog = new xDialog("/vst_admin/biz/prodTag/showAddProdTag.do?objectType=PROD_PRODUCT&tagGroupId="+brandTagGroupId,{},{title:title,width:800,heigh:700});
				return false;
			}				
		});
		
		// 批量删除标签
		$('#delProdTag').bind('click',function() {
			var size = $("input[type=checkbox][name=objectIds]:checked").size();
			if(size<=0){
				if($('#objectType').val()=='SUPP_GOODS'){
					$.alert('请选择删除标签的商品');
				}else{
					$.alert('请选择删除标签的产品');
				}
				return false;
			}else{
				var title = '批量删除标签';
				var objectType= $('#objectType').val();
				var tagGroup = $('#tagGroup').val();
				delDialog = new xDialog("/vst_admin/biz/prodTag/showDelProdTag.do?objectType=PROD_PRODUCT&tagGroupId="+brandTagGroupId,{},{title:title,width:800,heigh:700});
				
				return false;
			}			
		});	
		
		
		
		// 修改标签
		$('#updateProdTag').bind('click',function() {
			var size = $("input[type=checkbox][name=objectIds]:checked").size();
			if(size<=0){
				$.alert('请选择修改标签起止时间的品牌');
				return false;
			}else{
				var objectType= $('#objectType').val();
				var tagGroup = $('#tagGroup').val();
				var title = '修改标签';
				
				addDialog = new xDialog("/vst_admin/biz/prodTag/showUpdateTagTimePosition.do?objectType=PROD_PRODUCT&tagGroupId="+brandTagGroupId,{},{title:title,width:800,heigh:700});
				
				return false;
			}				
		});
		
		

		
		// 新增
		$('.add').bind('click',function() {
			var objectId = $(this).attr('data');
			var tagGroup = $('#tagGroup').val();
			var objectName = $(this).attr('data1');
			var objectType= $('#objectType').val();
			var title = '为'+objectName+'新增标签';		
			
			addDialog = new xDialog("/vst_admin/biz/prodTag/showAddProdTag.do?objectId="+objectId+"&objectType=PROD_PRODUCT&tagGroupId="+brandTagGroupId,{},{title:title,width:800,heigh:700});
			
			return false;
		});			
		
		
		// 修改	
		$('.update').bind('click',function() {
			var objectType= $('#objectType').val();
			var tagGroup = $('#tagGroup').val();
			var objectId = $(this).attr('data');
			var objectName = $(this).attr('data1');
			var title = '为'+objectName+'修改标签';
			
			updateDialog = new xDialog("/vst_admin/biz/prodTag/showUpdateProdTag.do?objectType=PROD_PRODUCT&objectId="+ objectId + "&tagGroupId=" + brandTagGroupId,{},{title:title,width:900,heigh:700});
			return false;			
		});			
		
		
		// 全选与取消
		$('.selectAll').bind('click',function() {
			 if($(this).attr('checked')=='checked'){
				 $("input[type=checkbox][name=objectIds]").attr('checked',true);			 	
			 }else{
			 	 $("input[type=checkbox][name=objectIds]").attr('checked',false);
			 }
		});
		
		 
		$('#tagGroup').bind('change',function() {
		
			$("#selectTagName").val("");
			var tagGroup = $('#tagGroup').val();
			if(tagGroup != '') {
				findAllTagNameByGroup();
			}
		});
		
		findAllTagNameByGroup();
	});
	
	
	// 根据小组名称查询有效标签
	function findAllTagNameByGroup(){
		$('#tagName').combobox({  
            url : "/vst_admin/biz/bizTag/findAllTagNameByGroup.do?iniAll="+encodeURIComponent(encodeURIComponent('全部'))+"&tagGroupId=" + $('#tagGroup').val(),
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
            		$('#tagName').combobox('setText','全部');
            	}
            }, 
            onLoadError:function(){
            	$.alert(result.message);
            }        
        });
	}
	

	
	function search() {
	
		var objectType= $('#objectType').val();
		var tagGroup = $('#tagGroup').val();
		var obj = $('#searchForm');
		
		obj.attr('action','/vst_admin/biz/prodTag/findBrandTagList.do');
		
		obj.submit();	
	}
	
	
</script>


