<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>玩法配置</title>
    <link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
	<link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
	<link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
	<link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
    <#include "/base/head_meta.ftl"/>
</head>

<body class="product-list">

<!--页面 开始-->
<div class="everything">
    <ol class="onionskin">
        <li>
            <a href="#">首页</a>
            <i>&gt;</i>
        </li>
        <li>
            <a href="#">玩法配置</a>
            <i>&gt;</i>
        </li>
    </ol>

    <!--筛选 开始-->
   <div class="filter">
        <form class="filter-form" method="post" action='/vst_admin/show/playMethod/findPlayMethod.do' id="searchForm">
            <div class="row">
                <div class="col">
                    <div class="form-group">
                    
                        <label>
                            <span class="w50">所属品类</span>
	                         <select class="form-control w90" name="categoryId">
	                   	 			<option value="">全部</option>
				    				<#list categoryList as category> 
				                    	<option value=${category.categoryId!''} <#if show_categoryId==category.categoryId>selected</#if>>${category.cnName!''}</option>
					                </#list>
				        	</select>
                        </label>
                    </div>
                </div>
           
                <div class="col">
                    <div class="form-group">
                        <label>
                            <span class="w8 inline-block text-right">玩法ID</span>
                            <input class="form-control w90" type="text" name="playMethodId" value="${show_playMethodId!''}" number="true">
                        </label>
                    </div>
                </div>
                
                <div class="col">
                    <div class="form-group">
                        <label>
                           <span class="w8 inline-block text-right">玩法名称</span>
                            <input class="form-control w90" type="text" name="name" value="${show_name!''}">
                        </label>
                    </div>
                </div>
                
                <div class="col">
                    <div class="form-group">
                        <label>
                          <span class="w8 inline-block text-right">是否有效</span>
                            <select class="form-control w90" name="validFlag">
                   					<option value="">全部</option>
			                    	<option value='Y'<#if show_validFlag == 'Y'>selected</#if>>有效</option>
			                    	<option value='N'<#if show_validFlag == 'N'>selected</#if>>无效</option>
                            </select>
                        </label>
                    </div>
                </div>
            
                <div class="col w4"></div>
                <div class="col w400">
                    <span class="btn-group">
	                    <a href="javascript:void(0);" class="btn btn_cc1" id="search_button" >查询</a>
                    </span>
                </div>
            </div>
            <#--第一行结束--> 
            <#--第二行开始--> 
            <div class="row">

            </div>
            <#--第二行结束--> 
        </form>
    </div>
    <!--筛选 结束-->

    <!--产品列表 开始-->
    <#if playMethodList??>
			<div class="product">
			    <table align="right">
				    <tr>
				      <td>
				        <a href="javascript:void(0);" class="btn btn_cc1" id="new_button" >新增玩法</a>
				      </td>
				    </tr>
			    </table>
			    
			    <table class="table table-border">
					        <colgroup>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					            <col class="w90"/>
					        </colgroup>
					        <thead>
					           <br/>
						        <tr>
						            <th>玩法ID</th>
						            <th>玩法名称</th>
						            <th>玩法拼音</th>
						            <th>所属品类</th>
						            <th>引用(产品)</th>
						            <th>引用次数</th>
						            <th>标红</th>
						            <th>是否有效</th>
						            <th>创建时间</th>
						            <th>更新时间</th>
						            <th>操作</th>
						        </tr>
					        </thead>
					        <tbody>
						        <tr>
									<#list playMethodList as playMethod> 
										<tr>
							            <td class="text-center">${playMethod.playMethodId}</td>
							            <td class="text-center">${playMethod.name!''}</td>
							            <td>${playMethod.pinyin!''}</td>
							            <td class="text-center">
									        <#list categoryList as category>
								                <#if category.categoryId == playMethod.categoryId>
								                  ${category.cnName!''}
								                </#if>
								            </#list>
							            </td>
							            <td class="text-center"><a href="javascript:void(0);" id="" data=${playMethod.playMethodId}>查看产品</a></td>
							            <td class="text-center">
							             <#if playMethod.prodBindCount == null>0
								         <#else>
								             ${playMethod.prodBindCount!''}
							             </#if>
							            </td>
							            <td class="text-center">
								              <#if playMethod.redFlag == "Y"> 
													<span>是</span>
											  <#elseif playMethod.redFlag == "N">
													<span>否</span>
											  <#else>
											        <span></span>
											  </#if>
							            </td>
							            <td class="text-center">
							              <#if playMethod.validFlag == "Y"> 
											<span style="color:green" class="cancelProp">有效</span>
										 <#elseif playMethod.validFlag == "N">
											<span style="color:red" class="cancelProp">无效</span>
									     <#else>
									        <span style="color:red" class="cancelProp"></span>
										 </#if>
							            </td>
							           
							            <td class="text-center">
							               <#if playMethod.createTime??>
							                   ${playMethod.createTime?string('yyyy-MM-dd HH:mm:ss')}
							               </#if>
							            </td>
							            <td class="text-center">
							                <#if playMethod.updateTime??>
							                   ${playMethod.updateTime?string('yyyy-MM-dd HH:mm:ss')}
							               </#if>
							            </td>
							            <td class="text-center">
							                <a href="javascript:void(0);" class="editPlayMethod" data=${playMethod.playMethodId}>修改</a>
							                <a href="javascript:void(0);" class="showLogDialog"
											   param='parentId=${playMethod.playMethodId}&parentType=PLAY_METHOD&sysName=VST'>操作日志</a>
							            </td>
							       
						            </#list>
						        </tr>
					        </tbody>
			    </table>
		        <table class="co_table">
			        <tbody>
			          <tr>
			            <td class="s_label">
			               <#if pageParam.items?exists>
							 <div class="paging" > 
								${pageParam.getPagination()}
							 </div> 
						   </#if>
			            </td>
			          </tr>
			        </tbody>
			    </table>
			</div>
			<#else>
			    <div class="hint mb10">
			        <span class="icon icon-big icon-info"></span>抱歉，查询暂无此产品
			    </div>
		    </#if>
    <!--产品列表 结束-->
    
    <div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
	</div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<script>

//查询
$("#search_button").bind("click",function(){
	//去掉左右的空格
    $("input[name=playMethodId]").val( $.trim($("input[name=playMethodId]").val()));
    $("input[name=name]").val( $.trim($("input[name=name]").val()));
    if(!$("#searchForm").validate().form()){
		return false;
	}
	$("#searchForm").submit();
});

var addMethodDialog;
var updateMethodDialog;
//添加玩法
$("#new_button").bind("click",function(){
	var url = "/vst_admin/show/playMethod/showAddPlayMethod.do";
	addMethodDialog =  new xDialog(url, {}, {title:"添加玩法",height:"550",width:700});
});

//修改
$("a.editPlayMethod").bind("click",function(){
	var url = "/vst_admin/show/playMethod/showUpdatePlayMethod.do";
	updateMethodDialog = new xDialog(url,{"playMethodId":$(this).attr("data")}, {title:"编辑玩法",height:"550",width:800});
});

</script>
