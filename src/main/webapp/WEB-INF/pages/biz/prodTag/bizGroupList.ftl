
<!-- 即将被删除 此页面-->
<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
		            <th width="40%">小组名称</th>
		            <th>操作</th>
	            </tr>
			</thead>
			<#if tagGroups?? &&  tagGroups?size &gt; 0>
				<#list tagGroups as item>
					<tr>
						<td>${item.tagGroupName}</td>
						<td><a class="btn btn_cc1" href="javascript:deleteGroup('${item.tagGroupId}');">删除</a></td>
					</tr>
				</#list>
			</#if>
		</tbody>
	</table>
</form>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	//删除小组
	function deleteGroup(tagGroupId){
		if(!confirm('确认删除该小组吗？')){
			return;
		}
		$.ajax({
			url : '/vst_admin/biz/bizTag/deleteGroup.do',
			dataType : 'json',
			type : 'post',
			data : {tagGroup: tagGroupId},
			success : function(result){
				if(result.code=='success'){
		 	 	   $.alert(result.message,function(){
			   			parent.search();
			   			parent.showAddOrUpdate.close();	
			 	 	 });
			 	   }else{
					  	$.alert(result.message);			 	 	 
			 	   }
					//alert(result.message);
				//	window.location.href = '/vst_admin/biz/bizTag/findBizTagList.do';
				}
		});
	}

</script>
	