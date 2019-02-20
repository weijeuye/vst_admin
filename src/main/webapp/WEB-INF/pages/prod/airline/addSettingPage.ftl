<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#assign voa=JspTaglibs["/WEB-INF/pages//tld/vstOrgAuthentication-tags.tld"]>
<#assign vpa=JspTaglibs["/WEB-INF/pages//tld/productAbandon-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>产品列表</title>
    <link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
    <style>
      #search_button1 {
            position: relative;
            display: inline-block;
            overflow: hidden;
      	}
   #search_button1 input
    {
    	position:absolute;
            right: 0px;
            top: 0px;
            opacity: 0;
            -ms-filter: 'alpha(opacity=0)';
            font-size: 200px;
    }
       
    </style>
</head>
<body class="product-list">
<input type="hidden" id="totalNum" value="${totalNum} ">
<input type="hidden" id="count" value="${count} ">
<input type="hidden" id="NoUsedIds" value="${NoUsedIds} ">

<!--页面 开始-->
<div class="everything">
    <!--筛选 开始-->
    <div class="filter">
        <form class="filter-form" method="post" action='/vst_admin/airlineQuery/findCAirLineAdd.do' id="searchForm">
        	<input type="hidden" name="productIdsStr" value="${productIdsStr!''}"/>
            <div class="row">
                <div class="col w160">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block">产品名称</span>
                            <input class="form-control w90" type="text" name="productName" <#if prodProduct??> value="${prodProduct.productName!''}" </#if>>
                        </label>
                    </div>
                </div>
                <div class="col w170">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block text-right">产品ID</span>
                            <input class="form-control w90" type="text" name="productId" <#if prodProduct??> value="${prodProduct.productId!''}" </#if> number="true" maxLength="11">
                        </label>
                    </div>
                </div>
                <div class="col w160">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block text-right">产品品类</span>
                            <select class="form-control w90" id="categoryId" name="bizCategory.categoryId">
                                <option value="" selected>不限</option>
			    				<#list bizCategoryList as bizCategory> 
				                    <option value=${bizCategory.categoryId!''} <#if prodProduct??&& prodProduct.bizCategory!=null && prodProduct.bizCategory.categoryId == bizCategory.categoryId>selected</#if> >${bizCategory.categoryName!''}</option>
				                </#list>
                            </select>

                        </label>
                    </div>
                </div>
                <div class="col w170">
                    <div class="form-group">
                        <label>
                            <span class="w50 inline-block text-right">产品经理</span>

                            <div class="inline-block">
                                <input class="search form-control w90" type="text" id="productManagerName" name="productManagerName" value="${productManagerName!''}">
                                <input type="hidden" id="productManagerId" name="productManagerId" value="${productManagerId!''}">
                            </div>
                        </label>
                    </div>
                </div>
                <div class="col w130">
                    <div class="form-group">
                        <label>
                            <span>产品状态</span>
                            <select class="form-control" name="cancelFlag">
                                <option value="">全部</option>
                                <option value='Y'<#if prodProduct?? && prodProduct.cancelFlag == 'Y'>selected</#if>>有效</option>
                                <option value='N'<#if prodProduct?? && prodProduct.cancelFlag == 'N'>selected</#if>>无效</option>
                            </select>
                        </label>
                    </div>
                </div>
                <div class="col w130">
                    <div class="form-group">
                        <label>
                            <span>是否可售</span>
                            <select class="form-control" name="saleFlag">
                                <option value="">全部</option>
                                <option value='Y' <#if prodProduct?? && prodProduct.saleFlag == 'Y'>selected</#if> >是</option>
                                <option value='N' <#if prodProduct?? && prodProduct.saleFlag == 'N'>selected</#if> >否</option>
                            </select>
                        </label>
                    </div>
                </div>
            </div>
            
             
                <div class="col w430"></div>
                <div class="col w100">
                    <span class="btn-group">
                    		<a class="btn btn-primary JS_btn_select" id="search_button">搜索</a>
                </div>
        </form>

    <form action="#" enctype="multipart/form-data" method="post"  id="formFileUpload">
      
    		<span class="btn btn-primary JS_btn_select" id="search_button1">
           	<span>批量导入产品ID</span>
            <input type="file"  name="myfile" id="fileUpload">
        	</span>
    </form>
    <br/>
       </div>
    <!--筛选 结束-->

   <!--产品列表 开始-->
    
<#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>

        <div class="product">
            <table class="table table-border">
                <colgroup>
                    <col class="w70"/>
                    <col class="w70"/>
                    <col class="product-name"/>
                    <col class="w50"/>
                    <col class="w50"/>
                    <col class="w200"/>
                    <col class="w70"/>
                    <col class="w160"/>
                </colgroup>
                <thead>
                <tr>
                    <th>品类</th>
                    <th>产品ID</th>  
                    <th class="product-name">产品名称</th>
                    <th>产品状态</th>
                    <th>是否可售</th>
                    <th>机票所属航司</th>
                    <th>设置</th>
                 	<th>航司限制</th>
                    
                </tr>
                </thead>
                <tbody>
                <tr>
                    <#list pageParam.items as product>
                    <tr sensitive="${product.senisitiveFlag}">
                        <td class="text-center"><#if product.bizCategory ??>${product.bizCategory.categoryName!''}</#if><#if product.bizCategory ?? && product.bizCategory.cancelFlag == 'N'><span class="notnull">[无效]</span></#if></td>
                        <td class="text-center">${product.productId!''}</td>
                        <td>${product.productName!''}</td>
                        <td class="text-center">
                            <#if product.cancelFlag == "Y">
                            <span class="text-success">有效
                            <#else>
                                <span class="text-danger">无效</span>
                            </#if>
                        </td>
                        <td class="text-center"><#if product.saleFlag =="Y">是<#else>否</#if></td>
                    	<td>${product.relationType!''}</td>
                    	
						<#if product.isG5 == "1">
						<td class="text-center">
                    	<a href="javascript:void(0);" class="showSetting" data=${product.productId}>设置</a>
                    	</td>
                    	<#else>
                    	<td class="text-center">
                    	   设置
                    	 </td>
                    	 </#if>                    	
                    	 
                    	<td>
                    	   <#list product.disIds as ary>
                    	   ${ary}
                            </#list>
                    	</td>
                    	
                    </#list>
                </tr>
                </tbody>
            </table>
            <#if pageParam.items?exists>
                <div class="page-box" > ${pageParam.getPagination()}</div>
            </#if>
        </div>

    <#else>
        <div class="hint mb10">
            <span class="icon icon-big icon-info"></span>抱歉，查询暂无此产品
        </div>
    </#if>
</#if>
    <!--产品列表 结束-->
    <div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:600px;">
    </div>
</div>

<!--脚本 模板 开始-->
<div class="template">

    <!--选择品类-->

    <!--选择品类-->
    <div class="dialog-category">
        <iframe src="about:blank" class="iframe-category" frameborder="0" style="width: 680px;"></iframe>
    </div>

    <!--废弃-->
    <div class="destroy">
        <p class="destroy-title text-danger">
            <span class="icon icon-big icon-danger"></span>
            <span class="destroy-text">警告！“废弃”后将无法在产品列表中呈现</span>
        </p>

        <p class="destroy-content">
            "是" "否" 继续该操作
        </p>

        <div class="btn-group">
            <a class="btn btn-primary JS_btn_yes">是</a>
            <a class="btn JS_btn_no">否</a>
        </div>
    </div>

    <!--公告-->
    <div class="notice">
        <iframe class="notice-iframe" src="about:blank" frameborder="0"></iframe>
    </div>

    <!--一句话推荐-->
    <div class="recommend">
        <iframe class="recommend-iframe" src="about:blank" frameborder="0"></iframe>
    </div>

    <!--礼品-->
    <div class="gift">
        <iframe class="gift-iframe" src="about:blank" frameborder="0"></iframe>
    </div>


</div>
<!--脚本 模板 结束-->

</body>
</html>
<!--页面 结束-->
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<link rel="stylesheet" href="/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.form.js"></script>
<script> 
        // 批量导入产品ID
         $("#fileUpload").live("change",function(){
        	FileUpload();
        });
        
        function FileUpload() {
			$.ajax({
				url : "/vst_admin/airlineQuery/batchImport.do",
				type : "post",
				processData: false,
				contentType: false,
				async: false,
				data : new FormData( $("#formFileUpload")[0] ),
				success : function(result) {
					$("[name=productIdsStr]").val(result[0]);
					if(result[0]=='f')
					{
						var txt="Excel导入数据格式有误，请直接将产品ID放第一列重新导入";
			    			$.confirm(txt,function(){
			    				 $("#search_button").click();
								 $('#fileUpload').replaceWith('<input  type="file" id="Uploadfile"  />'); 
			    			});
					}
					else
					{
					    if(result[1]<101)
					    {
				    	 if(result[1]==result[2])
			 	   			{ 
							 var txt="成功导入产品数据<span style='color: red;'> "+result[2]+"</span>条，导入失败数据 <span style='color: red;'>0</span> 条";
				    			$.confirm(txt,function(){
				    				 $("#search_button").click();
									 $('#fileUpload').replaceWith('<input  type="file" id="Uploadfile"  />'); 
				    			});
				    			 
			 	   			}
			 	   			else
			 	   			{	
			 	   				var a=result[1]-result[2];
			 	   			    var txt="成功导入产品数据 <span style='color: red;'>"+result[2]+"</span>条，导入失败数据 <span style='color: red;'>"+a+"</span>条。 <br/> 导入失败产品ID：<span style='color: red;word-wrap: break-word;'>"+result[3]+"</span>请重新核实产品ID。";
			    			$.confirm(txt,function(){
			    				 $("#search_button").click();
								 $('#fileUpload').replaceWith('<input  type="file" id="Uploadfile"  />'); 
			    			});
			    		
			 	   		 	}
					    }
					}
					},
					   error : function(){
						    alert("操作超时！"); 
					   }
					});	
        		}
        
        //查询
        $("#search_button").bind("click",function(){
            if(!$("#searchForm").validate().form()){
                return false;
            }
            $(".iframe-content").empty();
            $(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
            //去掉左右的空格
            $("input[name=productName]").val( $.trim($("input[name=productName]").val()));
            $("input[name=productId]").val( $.trim($("input[name=productId]").val()));
            $("input[name=goodsId]").val( $.trim($("input[name=goodsId]").val()));
            $("input[name=suppProductName]").val( $.trim($("input[name=suppProductName]").val()));
            $("#districtName").val( $.trim($("#districtName").val()));
            $("#searchForm").submit();
        });
        
    vst_pet_util.superUserSuggest("#productManagerName","#productManagerId");
    vst_pet_util.destListSuggest("#destName","#destId", true);
    
    var selectMethodDialog;
    //设置
    $("a.showSetting").bind("click",function(){
        var productId = $(this).attr("data");
        selectMethodDialog=  new xDialog("/vst_admin/airlineQuery/addSavePage.do?productId="+productId+"",{},{title:"设置",width:1040,iframe:true,scrolling:"yes"});
    });
</script>
