<!DOCTYPE html>
<html>
<head>
   <#include "/base/head_meta.ftl"/>
</head>
<body>
   <div class="iframe_header">
       <ul class="iframe_nav">
           <li><a href="javascript:void(0);">首页</a> &gt;</li>
           <li><a href="javascript:void(0);">产品管理</a> &gt;</li>
           <li class="active">预定条件配置</li>
           <li>&nbsp;&nbsp;*该配置页面中的限制条件仅对总公司及分公司的产品有效，对子公司产品不生效。</li>
       </ul>
   </div>
   <div class="iframe_content">
       <div class="p_box">
           <table class="p_table table_center">
               <thead>
                   <th>ID</th>
                   <th>限制类型</th>
                   <th width="500px">预订限制</th>
                   <th>运营类别</th>
                   <th width="300px">目的地</th>
                   <th>操作</th>
               </thead>
               <tbody>
               <#if bizReserveLimitList?size &gt; 0>
                   <#list bizReserveLimitList as limit>
                   <tr>
                       <td>${limit.reserveLimitId}</td>
                       <td>${limit.reserveName}</td>
                       <td style="text-align: left">${limit.reserveContent}</td>
                       <td>
                           <#if limit.operationCategory == 'LONGGROUP'>
                               长线
                           <#elseif limit.operationCategory == 'SHORTGROUP'>
                               短线
                           </#if>
                       </td>
                       <td>${limit.destNameStr}</td>
                       <td class="oper">
                           <a href="javascript:void(0);" class="syncLimit">同步数据</a>
                           <a href="javascript:void(0);" class="editLimit">编辑</a>
                           <a href="javascript:void(0);" class="showLogDialog" param='objectId=${limit.reserveLimitId}&objectType=RESERVE_LIMIT_OPERATE&sysName=VST'>操作日志</a>
                           <form id="dataForm">
                               <input type="hidden" name="reserveLimitId" value="${limit.reserveLimitId}"/>
                               <input type="hidden" name="reserveType" value="${limit.reserveType}"/>
                               <input type="hidden" name="reserveName" value="${limit.reserveName}"/>
                               <input type="hidden" name="operationCategory" value="${limit.operationCategory}"/>
                               <input type="hidden" name="ageUpperLimit" value="${limit.ageUpperLimit}"/>
                               <input type="hidden" name="ageLowerLimit" value="${limit.ageLowerLimit}"/>
                               <input type="hidden" name="destNameStr" value="${limit.destNameStr}"/>
                           </form>
                       </td>
                   </tr>
                   </#list>
               </#if>
               </tbody>
           </table>
           <#if pageParam.items?exists>
		       <div class="paging" >
                   ${pageParam.getPagination()}
               </div>
           </#if>
       </div>
   </div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
    var dialog, data, url, si, loading;
    $(".editLimit").bind("click", function(){
        data = $(this).closest(".oper").find("#dataForm").serialize();
        if(data == null || data == undefined){
            return;
        }
        url = "/vst_admin/biz/reserveLimit/editReserveLimit.do";
        dialog = new xDialog(url, data, {title:"编辑预定限制", height:550, width:600});
    });

    $(".syncLimit").bind("click", function(){
        var $obj = $(this);
        $.confirm("请确保您已与相关负责人就限制条件达成一致意见。", function(){
            syncData($obj);
        });
    });

    function syncData(obj) {
        data = obj.closest(".oper").find("#dataForm").serialize();
        loading = pandora.loading("数据同步中，请稍等...");
        $.ajax({
            url:"/vst_admin/biz/reserveLimit/syncReserveLimit.do",
            type:"post",
            dataType:"json",
            data:data,
            success:function(result){
                if(result.code=="success"){
                    si = setInterval(function(){
                        asyncQueryCompleteFlag(result.attributes.token);
                    }, 5000);
                }else{
                    if(loading){
                        loading.close();
                    }
                    $.alert(result.message);
                }
            },
            error:function(){
                loading.close();
                $.alert("请求失败");
            }
        });
    }

    function asyncQueryCompleteFlag(obj) {
        $.ajax({
            url:"/vst_admin/biz/reserveLimit/querySyncHasCompleted.do",
            type:"post",
            dataType:"json",
            data:{'token':obj},
            success:function(result){
                if(result.attributes.hasCompleted == "Y"){
                    clearInterval(si);
                    loading.close();
                    $.alert("同步数据完成");
                }
            },
            error:function(){
                console.log("查询同步数据是否完成请求失败");
            }
        });
    }
</script>