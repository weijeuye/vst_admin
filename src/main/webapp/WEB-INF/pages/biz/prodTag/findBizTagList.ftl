<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#import "/base/spring.ftl" as s/>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">首页</a> &gt;</li>
            <li><a href="#">标签与主题</a> &gt;</li>
            <li class="active">标签配置</li>
        </ul>
</div>
<div class="iframe_content">
    <div class="p_box box_info">
		<form method="post" action='/vst_admin/biz/bizTag/findBizTagList.do' id="searchForm">
	        <table class="s_table">
	            <tbody>
	                <tr>
	                	<td class="s_label">小组名称：</td>
	                    <td class="w18">
	                    	<select name="tagGroupId" id="tagGroup">
	                    		<option value="">全部</option>
	                    		<#list tagGroups as tagGroup>
	                    			<option value="${tagGroup.tagGroupId}" <#if (bizTag.tagGroupId == tagGroup.tagGroupId)>selected</#if>>
	                    				${tagGroup.tagGroupName}
	                    			</option>
	                    		</#list>
	                    	</select>
	                    </td>
	                 	<td class="s_label">标签名称：</td>
	                    <td class="w18">
	                    	<input type="hidden"  id="selectTagName" value="${bizTag.tagName}"/>
	                        <select name="tagName" id="tagName">
				        	</select>
	                    </td>
	                    <td class="s_label">标签状态：</td>
	                    <td class="w18">
				        	<select class="w9" name="cancelFlag">
	                        	<option value=""  <#if (bizTag.cancelFlag == "")>selected</#if>>请选择</option>
	                            <option value="Y" <#if (bizTag.cancelFlag == "Y")>selected</#if>>有效</option>
	                            <option value="N" <#if (bizTag.cancelFlag == "N")>selected</#if>>无效</option>
	                    	</select>
	                    </td>
	                    
	                    <td class=" operate mt10">
		                   	<a class="btn btn_cc1" id="search_button">查询</a> 
	                    </td>
	                </tr>
	            </tbody>
	        </table>	
		</form>
	</div>
	<div align="right">
	<a class="btn btn_cc1" id="updateTagGroup">修改标签小组</a>
	<a class="btn btn_cc1" id="batchUpdateBizTag">批量修改标签</a>
	<a class="btn btn_cc1" id="showAddBizTag">新增标签</a>
	</div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
	    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
		    <div class="p_box box_info">
		    	<table class="p_table table_center" style="margin-top: 10px;">
		            <thead>
		                <tr>
		                	<th width="60">&nbsp;<input type="checkbox" class="selectAll"/></th>
		                	<th width="80px">小组名称</th>
		                    <th>标签名称</th>
		                    <th>二级名称</th>
		                    <th>SEQ</th>
		                    <th>状态</th>
		                    <th width="350px">操作</th>
		                </tr>
		            </thead>
		            <tbody>
						<#list pageParam.items as bizTag> 
						<tr>
							<td><input type="checkbox" value="${bizTag.tagId}" name="objectIds"/></td>
							<td>${bizTag.bizTagGroup.tagGroupName!''}</td>
							<td>${bizTag.tagName!''}</td>
							<td>${bizTag.secondaryTagName!''}</td>
							<td><a href="javascript:void(0);" class="editBizTagSeq" data="${bizTag.tagId!''}">${bizTag.seq!''}</a></td>
							<td><#if bizTag.cancelFlag == 'N'>无效<#else>有效</#if></td>	
							<td class="oper">
		                        <a href="javascript:void(0);" class="showBizTag" data="${bizTag.tagId!''}">查看</a>
		                        <a href="javascript:void(0);" class="editBizTag" data="${bizTag.tagId!''}">修改</a>
		                        <a href="javascript:void(0);" class="showLogDialog"
								   param="parentId=${bizTag.tagId}&parentType=TAG_SUBJECT&sysName=VST">操作日志</a>
		                    	
		                    	<@mis.checkPerm permCode="5257">
		                    		<!-- <a href="javascript:void(0);" class="delBizTag" data="${bizTag.tagId!''}">删除</a> -->	
		                    	</@mis.checkPerm >
		                    </td>
						</tr>
						</#list>
		            </tbody>
		        </table>
				<#if pageParam.items?exists> 
					<div class="paging" > 
						${pageParam.getPagination()}
					</div> 
				</#if>
			</div><!-- div p_box -->
		<#else>
			<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关信息，重新输入相关条件查询！</div>
	    </#if>
    </#if>
<!-- //主要内容显示区域 -->
</div>
<form id="selectTagNameForm">
</form>	
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	
	var showAddOrUpdate;
	var tagGroupDialog;
	
	$(function(){
		
		// 设置菜单
		$('.J_list',window.parent.document).find('li').eq(2).click();
		
		// 查询
		$('#search_button').bind('click',function(){
			$("#searchForm").submit();
		});

        // 跳转到只修改seq页面
        $(".editBizTagSeq").bind("click",function(){
            var tagId = $(this).attr('data');
            showAddOrUpdate = new xDialog("/vst_admin/biz/bizTag/showUpdateBizTagSeq.do?tagId="+tagId,{},{title:"修改SEQ",width:500});
            return;
        });
		
		// 跳转到新增页面
		$("#showAddBizTag").bind("click",function(){
			showAddOrUpdate = new xDialog("/vst_admin/biz/bizTag/showSaveOrUpdateBizTag.do?",{},{title:"新增标签",iframe:true,width:1200,height:800});
			return;
		});	
		
		// 跳转到修改页面
		$(".editBizTag").bind("click",function(){
			var tagId = $(this).attr('data');
			showAddOrUpdate = new xDialog("/vst_admin/biz/bizTag/showSaveOrUpdateBizTag.do?tagId="+tagId,{},{title:"修改标签",iframe:true,width:1200,height:800});
			return;
		});
		
		// 删除标签
		$(".delBizTag").bind("click",function(){
			if(confirm("确认删除该标签吗？")){
				var tagId = $(this).attr('data');
				$.ajax({
					url : '/vst_admin/biz/bizTag/deleteTag.do?tagId='+tagId,
					type : 'post',
					dataType : 'json',
					success : function(result){
						if(result.code == 'success'){
							//window.location.reload();
							search();
						}
						alert(result.message);
					}
				});
			}
		});
		
		// 跳转到查看页面
		$(".showBizTag").bind("click",function(){
			var tagId = $(this).attr('data');
			showAddOrUpdate = new xDialog("/vst_admin/biz/bizTag/findProdTagByTagId.do?tagId="+tagId+"&objectType=PROD_PRODUCT",{},{title:"标签关联的产品和商品",iframe:true,width:800,height:700});
			return;
		});	
		
		// 全选与取消
		$('.selectAll').bind('click',function(){
			 if($(this).attr('checked')=='checked'){
				 $("input[type=checkbox][name=objectIds]").attr('checked',true);			 	
			 }else{
			 	 $("input[type=checkbox][name=objectIds]").attr('checked',false);
			 }
		});
		
		$("#updateTagGroup").bind('click',function(){
			tagGroupDialog = new xDialog("/vst_admin/biz/bizTag/showSetTagGroup.do",{},{title:"修改标签小组", iframe:true,width:800, iframeHeight:400});
		});
		// 批量修改标签
		$('#batchUpdateBizTag').bind('click',function(){
			var size = $("input[type=checkbox][name=objectIds]:checked").size();
			if(size<=0){
				$.alert('请选择批量修改的标签');
				return false;
			}else{
				var title = '批量修改标签';			
				showAddOrUpdate = new xDialog("/vst_admin/biz/bizTag/batchUpdateBizTag.do",{},{title:title,width:800,heigh:700});
				return false;
			}				
		});
		
		$('#tagGroup').bind('change',function(){
		
			$("#selectTagName").val("");
			findAllTagNameByGroup();
		});		
		
		findAllTagNameByGroup();		
	});
	
	// 查询
	function search(){
		$("#searchForm").submit();
	}
	
   // 创建表单元素
   function createItem(name,value){
 	   $("#selectTagNameForm").append('<input type=hidden name='+name+' value='+value+'>');
   }	
	
	// 根据小组名称查询标签
	function findTagNameByGroup(){
		var tagGroup = $('#tagGroup').val();
		var selectTagName = $('#selectTagName').val();
		$('#selectTagNameForm').empty();
		createItem('tagGroup',tagGroup);
		$.ajax({
			url : "/vst_admin/biz/bizTag/findTagNameByGroup.do",
			type : "post",
			async: false,
			data : $("#selectTagNameForm").serialize(),
			success : function(result) {
				$('#tagName').empty();
				$('#tagName').append("<option value=\'\'>全部</option>");
				$.each(result,function(index,data){
					if(selectTagName==data.tagName){
						$('#tagName').append("<option selected value=\'"+data.tagName+"\'>"+data.tagName+"</option>");
					}else{
						$('#tagName').append("<option value=\'"+data.tagName+"\'>"+data.tagName+"</option>");
					}
				});
			},
			error : function(result) {
				$.alert(result.message);
			}
		});		
	}	

	function findAllTagNameByGroup(){
	
		$('#tagName').combobox({  
            url : "/vst_admin/biz/bizTag/findAllTagNameByGroup.do?isAll=Y&iniAll="+encodeURIComponent(encodeURIComponent('全部'))+"&tagGroupId=" + $('#tagGroup').val(),
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
	
</script>


