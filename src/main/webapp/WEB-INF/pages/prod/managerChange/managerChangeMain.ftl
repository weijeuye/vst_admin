<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<#assign voa=JspTaglibs["/WEB-INF/pages//tld/vstOrgAuthentication-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>产品列表</title>

    <link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>


    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
    <link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
</head>
<body class="product-list">

<!--页面 开始-->
<div class="everything">

    <!--洋葱皮-->
    <ol class="onionskin">
        <li>
            <a href="#">首页</a>
            <i>&gt;</i>
        </li>
        <li>
            <a href="#">产品管理</a>
            <i>&gt;</i>
        </li>
        <li>
            酒店产品归属变更
        </li>
    </ol>


    <!--筛选 开始-->
    <div class="filter">
        <form class="filter-form" method="post" id="searchForm" action="#">
            <div class="row">
                <div class="col w260">
                    <div class="form-group">
                        <label>
                            <span class="w90 inline-block text-right">产品经理</span>

                            <div class="inline-block">
                                <input class="search form-control w90" type="text" id="managerName" name="managerName"
                                       value="${managerName!''}">
                                <input type="hidden" id="managerId" name="managerId" value="${managerId!''}">
                            </div>
                        </label>
                    </div>
                </div>
            
                 <div class="col w400">
                    <div class="form-group">
                    <span class="w80 inline-block text-right"><input type="checkbox"  id="prodProductCheckBox" name="categoryIds" value="1"/>酒店产品</span>
                    <span class="w80 inline-block text-right"><input type="checkbox"  id="hotelCombCheckBox" name="categoryIds" value="17"/>酒店套餐</span>
                     <span class="w70 inline-block text-right"><input type="checkbox"  id="freedomCheckBox" name="categoryIds" value="18"/>自由行</span>
                   
                    </div>
                  
                  
                  </div>
                <div class="col w250">
                    <span class="btn-group">
                            <a class="btn btn-primary JS_btn_select" id="search_product_button">查询产品</a>
                            <a class="btn btn-primary JS_btn_select" id="search_suppGoods_button">查询酒店商品</a>
                    </span>
                </div>
            </div>
            <div class="row">

                <div class="col w250">
                    <div class="form-group">
                        <label>
                            <span class="w90 inline-block text-right">离职产品经理</span>

                            <div class="inline-block">
                                <input class="search form-control w90" type="text" id="oldManagerName" name="oldManagerName" value="${oldManagerName!''}">
                                <input type="hidden" id="oldManagerId" name="oldManagerId" value="${oldManagerId!''}">
                            </div>
                        </label>
                    </div>
                </div>
                <div class="col w250">
                    <div class="form-group">
                        <label>
                            <span class="w90 inline-block text-right">交接产品经理</span>

                            <div class="inline-block">
                                <input class="search form-control w90" type="text" id="newManagerName" name="newManagerName" value="${newManagerName!''}">
                                <input type="hidden" id="newManagerId" name="newManagerId" value="${newManagerId!''}">
                            </div>
                        </label>
                    </div>
                </div>
                </div>
                 <div class="row">
                 
                 <div class="col w100">
                 <lable>
                 <span class="w90 inline-block text-right">变更类目:</span>
                 </lable>
                 </div>
                <div class="col w400">
                    <div class="form-group">
                    <span class="w80 inline-block text-right"><input type="checkbox"  id="prodProductCheckBox1" name="changeScope" value="1"/>酒店产品</span>
                    <span class="w80 inline-block text-right"><input type="checkbox"  id="suppGoodsCheckBox" name="suppGoods" value="suppGoods"/>酒店商品</span>
                     <span class="w80 inline-block text-right"><input type="checkbox"  id="hotelCombCheckBox1" name="changeScope" value="17"/>酒店套餐</span>
                    <span class="w70 inline-block text-right"><input type="checkbox"  id="freedomCheckBox1" name="changeScope" value="18"/>自由行</span>
                    </div>
                </div>
                </div>

              <div class="row">
                <div class="col w400">
            
               
              
                
                    <span class="btn-group text-right">
                            <a class="btn btn-primary JS_btn_select " id="changeManager_button">变更</a>
                    </span>
                    
                 
                    <span class="btn-group text-right">																					 																		
                            <a href="javascript:void(0)"  class="btn btn-primary JS_btn_select showLogDialog" id="queryOperator_button"  param='objectId=567891&objectType=MANAGER_CHANGE_OPRATE&logType=MANAGER_CHANGE_CATEORYSANDGOODS&sysName=VST'>查看操作日志</a>
                    </span>
                    </div>
                   
                    </div>
                </div>


        </form>
    </div>
    <!--筛选 结束-->

    <!--产品列表 开始-->
<#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>

        <#if listType="prodProduct">
            <div class="product">
                <table class="table table-border">
                    <colgroup>
                         <col class="w100"/>
                        <col class="w100"/>
                        <col class="product-name"/>
                        <col class="w100"/>
                        <col class="w100"/>
                        <col class="w100"/>
                        <col class="w20p"/>
                    </colgroup>
                    <thead>
                    <tr><th>品类</th>
                        <th>产品ID</th>
                        <th class="product-name">产品名称</th>
                        <th>产品状态</th>
                        <th>是否可售</th>
                        <th>审核状态</th>
                        <th>推荐级别</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <#list pageParam.items as product>
                        <tr sensitive="${product.senisitiveFlag}">
                            <td class="text-center">${product.bizCategoryName}</td>
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
                            <td>
                                <#if product.auditStatus??>
                                    <#list auditTypeList as audit>
                                        <#if product?? && product.auditStatus==audit.code>${audit.cnName}</#if>
                                    </#list>
                                    <br/>
                                    <#if product.senisitiveFlag=='Y'><span class="text-danger">(敏感词)</span></#if>
                                </#if>
                            </td>
                            <td class="text-center">${product.recommendLevel}</td>

                        </#list>
                    </tr>
                    </tbody>
                </table>
                <#if pageParam.items?exists>
                    <div class="page-box"> ${pageParam.getPagination()}</div>
                </#if>
            </div>
        </#if>
        <#if listType="suppGoods">

            <div class="p_box box_info">

                <table id="suppGoodsTable" class="p_table table_center tablesorter">
                    <thead>
                    <tr>
                        <th>商品编号</th>
                        <th>商品名称</th>
                        <th>规格ID</th>
                        <th>规格名称</th>
                        <th>产品ID</th>
                        <th>产品名称</th>
                        <th>是否有效</th>
                    </tr>
                    </thead>
                    <tbody>
                        <#list pageParam.items as suppGoods>
                        <tr>
                            <td>${suppGoods.suppGoodsId!''} </td>
                            <td>${suppGoods.goodsName!''} </td>
                            <td>${suppGoods.prodProductBranch.productBranchId}</td>
                            <td>${suppGoods.prodProductBranch.branchName!''}</td>
                            <td>${suppGoods.prodProduct.productId}</td>
                            <td>${suppGoods.prodProduct.productName}</td>

                            <td>
                                <#if suppGoods.cancelFlag == "Y">
                                    <span style="color:green" class="cancelProp">有效</span>
                                <#else>
                                    <span style="color:red" class="cancelProp">无效</span>
                                </#if>
                            </td>
                        </tr>
                        </#list>

                    </tbody>
                </table>
                <#if pageParam.items?exists>
                    <div class="page-box"> ${pageParam.getPagination()}</div>
                </#if>
            </div>
        </#if>
    <#else>
        <div class="hint mb10">
            <span class="icon icon-big icon-info"></span>抱歉，查询暂无数据
        </div>
    </#if>
</#if>
</div>

</body>
</html>
<!--页面 结束-->
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
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


<script>


    vst_pet_util.superUserSuggest("#managerName","#managerId");
    vst_pet_util.superUserSuggest("#oldManagerName","#oldManagerId");
    vst_pet_util.superUserSuggest("#newManagerName","#newManagerId");

    $(function () {

          
        //查询商品
        $("#search_suppGoods_button").bind("click", function () {

            var managerName=$("#managerName").val();
            var managerId = $("#managerId").val();
  
            if(managerName=="" || managerId==""){
                $.alert("请选择产品经理");
                return;
            }
   //         if(!($("#prodProductCheckBox").is(":checked")||$("#hotelCombCheckBox").is(":checked")||$("#freedomCheckBox").is(":checkded"))){
    //             $.alert("请选择变更范围")
   //             return;
     //       } 
            
            $(".iframe-content").empty();
            $(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
            $("#searchForm").attr("action", "/vst_admin/prod/managerChange/findSuppGoodsList.do");
            $("#searchForm").submit();

        });

        //查询产品
        $("#search_product_button").bind("click", function () {
            var managerName=$("#managerName").val();
            var managerId = $("#managerId").val();
            if(managerName=="" || managerId==""){
                $.alert("请选择产品经理");
                return;
            }
            $(".iframe-content").empty();
            $(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
            $("#searchForm").attr("action", "/vst_admin/prod/managerChange/findProductList.do");
            $("#searchForm").submit();
        });


    });
     
    //更换产品经理
    $("#changeManager_button").bind("click", function () {

        var oldManagerName=$("#oldManagerName").val();
        var oldManagerId=$("#oldManagerId").val();
        var newManagerName=$("#newManagerName").val();
        var newManagerId=$("#newManagerId").val();

        if(oldManagerName=="" || oldManagerId==""){
            $.alert("请选择离职产品经理");
            return;
        }
        if(newManagerName=="" || newManagerId==""){
            $.alert("请选择交接产品经理");
            return;
        }

        if(!($("#prodProductCheckBox1").is(":checked") || $("#suppGoodsCheckBox").is(":checked")||$("#hotelCombCheckBox1").is(":checked")||$("#freedomCheckBox1").is(":checked"))){
            $.alert("请选择变更范围")
            return;
        }
         var confirmContent=null ;
         $.ajax({
              url : "/vst_admin/prod/managerChange/queryOpeatorOfChangeManager.do",
            type : "post",
            dataType:"json",
            async: false,
            data : $("#searchForm").serialize(),
            success:function(result){
              if(result.code=='bothNone'){
                 $.alert("没有要变更的数据");
                 return;
              }else if(result.code=='NoGOOds'){
                 $.alert("没有变更的商品");
                 return ;
              }else if(result.code=='NoProduct'){
                  $.alert("没有变更的商品");
                  return;
               }
              else if(result.code=='confirmContent'){
                  confirmContent = result.message;
               }else {
                   $.alert("系统异常");
                   return;
               }
            }
         
         })
        if(confirmContent!=null){
      	$.confirm("确认"+confirmContent, function (){
        $.ajax({
            url : "/vst_admin/prod/managerChange/doChangeManager.do",
            type : "post",
            dataType:"json",
            async: false,
            data : $("#searchForm").serialize(),
            success : function(result) {
                if(result.code=='success'){
                    $.alert("产品经理变更成功");
                }else if(result.code=='bothNone'){
                    $.alert("该产品经理下无酒店产品和商品");
                }else if(result.code=='noProduct'){
                    $.alert("该产品经理下无酒店产品");
                }else if(result.code=='noSuppGoods'){
                    $.alert("该产品经理下无酒店商品");
                }else{
                    $.alert("产品经理变更失败");
                }
            }
        });
        });
       }
        
    });
 
</script>