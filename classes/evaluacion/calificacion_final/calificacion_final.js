function FCargando(accion)
{
    if (accion == 0)
    {
        $('#gif_espera').html(`&nbsp;`);
    }
    else if (accion == 1)
    {
        $('#gif_espera').html(`
            <img src="/p/imagenes/ajax-loader.gif" width="35" height="35"><br>
            Espere
        `);
    }
}

function mostrarSeccionOrdinarias()
{
    //console.log("Entro a mostrarSeccionOrdinariaszzzzz");
    var pagina = "";

    var par = {
        intCveCarrera: $('#cmbCarrera').val(),
        intCvePeriodo: $('#cmbPeriodo').val()
    };

            $.ajax({
                data: par,
                url: ('calificacion_final/tabla_actas_ordinarias.jsp'),
                type: 'POST',
                dataType: 'HTML',
                success: (res) => {
//          console.log('res => ', res);                                                                        
                            $('#AjaxOrdinarias').html(res);
                        },
                        error: (err) => {
                            console.log('err => ', err);
                    
                            alert('Error al intentar recuperar los datos de las actas de calificaciones PAR.');
                        }
                    });
}

function mostrarSeccionComplementarias()
{
    var pagina = "";

    var par = {
        intCveCarrera: $('#cmbCarrera').val(),
        intCvePeriodo: $('#cmbPeriodo').val()
    };

            $.ajax({
                data: par,
                url: ('calificacion_final/tabla_actas_complementarias.jsp'),
                type: 'POST',
                dataType: 'HTML',
                success: (res) => {
//          console.log('res => ', res);                                                                        
                            $('#AjaxComplementarias').html(res);
                        },
                        error: (err) => {
                            console.log('err => ', err);
                    
                            alert('Error al intentar recuperar los datos de las actas de calificaciones COM.');
                        }
                    });
}

function mostrarSeccionEspecialesRegularizacion()
{
    var pagina = "";

    var par = {
        intCveCarrera: $('#cmbCarrera').val(),
        intCvePeriodo: $('#cmbPeriodo').val()
    };

            $.ajax({
                data: par,
                url: ('calificacion_final/tabla_actas_especiales_regularizacion.jsp'),
                type: 'POST',
                dataType: 'HTML',
                success: (res) => {
//          console.log('res => ', res);                                                                        
                            $('#AjaxEspeciales').html(res);
                        },
                        error: (err) => {
                            console.log('err => ', err);
                    
                            alert('Error al intentar recuperar los datos de las actas de calificaciones.');
                        }
                    });
}

function mostrarSeccionUltimaAsignatura()
{
    var pagina = "";

    var par = {
        intCveCarrera: $('#cmbCarrera').val(),
        intCvePeriodo: $('#cmbPeriodo').val()
    };

            $.ajax({
                data: par,
                url: ('calificacion_final/tabla_actas_ultima_asignatura.jsp'),
                type: 'POST',
                dataType: 'HTML',
                success: (res) => {
//          console.log('res => ', res);                                                                        
                            $('#AjaxUltimaAsignatura').html(res);
                        },
                        error: (err) => {
                            console.log('err => ', err);
                    
                            alert('Error al intentar recuperar los datos de las actas de calificaciones.');
                        }
                    });
}

function FIniciar() 
{
    $(document).ajaxStart(() => FCargando(1));

    $(document).ajaxStop(() => FCargando(0));

    $('#cmbCarrera').on("change",function(){   
    //alert("carrera");    
    //console.log("antes de mostrarSeccionOrdinarias"); 
        mostrarSeccionOrdinarias();  
//        mostrarSeccionComplementarias();  
//        mostrarSeccionEspecialesRegularizacion();
//        mostrarSeccionUltimaAsignatura();
    });

    $('#btnSalir').click(function(){      
        //alert("Hola");
        FSalir();
    }); 

/*
    $('#btnCancelarEnvioOrdinarias').click(function(){  

        if (confirm("ESTAS SEGURO DE QUE QUIERES CANCELAR EL ENVÍO DEL ACTA DE CALIFICACIONES ORDINARIAS?") == true) 
        {     
            //alert("Cancelar ORDINARIAS");   
            cancelarEnvioDeActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa);
        } 
    });         
*/
}

//function FActa_ordinaria(valor,grado,opcion_calif, nom_grupo)
function FActa_ordinaria(intCveCarrera, intCveGrupo, intCvePeriodo, intOpcionCalif)
{
    /*
    alert("Llego a FActa_ordinaria");
    console.log("intCveCarrera -- " + intCveCarrera);
    console.log("intCveGrupo -- " + intCveGrupo);
    console.log("intCvePeriodo -- " + intCvePeriodo);
    console.log("intOpcionCalif -- " + intOpcionCalif);
*/
        var URL ="calificacion_con_sin_competencia.jsp?cve_carrera=" + intCveCarrera;
        URL = URL + "&cve_grupo=" + intCveGrupo;
        URL = URL + "&cve_periodo=" + intCvePeriodo;
        URL = URL + "&opcion_calif=" + intOpcionCalif;

//        alert(URL);
        var ventana = window.open(URL,"calificacion_normal","status=yes,toolbar=yes,scrollbars=yes,resizable=yes,width=700,height=500");
}

function FActa_complementaria(intCveCarrera, intCveGrupo, intCvePeriodo, intOpcionCalif)
{
        var URL ="calificacion_extra.jsp?cve_carrera=" + intCveCarrera;
        URL = URL + "&cve_grupo=" + intCveGrupo;
        URL = URL + "&cve_periodo=" + intCvePeriodo;
        URL = URL + "&opcion_calif=" + intOpcionCalif;
//alert(URL);
        var ventana = window.open(URL,"calificacion_complementaria","status=yes,toolbar=yes,scrollbars=yes,resizable=yes,width=700,height=500");
}

function FDocentes_adeudo(intCvePeriodo, cve_grupo, intOpcionCalif, BanderaImprimeActa)
{
    var URL ="dozentez_zin_termino.jsp?cve_grupo="+cve_grupo + "&intOpcionCalif=" + intOpcionCalif + "&intCvePeriodo=" + intCvePeriodo + "&intBanderaImprimeActa=" +BanderaImprimeActa;

    ventana = open(URL,"docentes_faltantes","status=yes,scrollbars=yes, top=20, left=250, width =1000,height =700,resizable =yes");
}

/************************************************************************************
    DESCRIPCION: Cancelar el envío de acta por parte del director
    CREADO POR: Nancy Alegría López
    FECHA: 01/04/2019
************************************************************************************/
/*
function cancelarEnvioDeActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa)
{
  alert("eNTRO A cancelarEnvioDeActaPorDirectorRRRR");
  alert(intCvePeriodo);
  alert(intCveCarrera);
  alert(intCveGrupo);
  alert(intTipoActa);
    var parametros = {
        "intCvePeriodo" : intCvePeriodo,
        "intCveCarrera" : intCveCarrera,
        "intCveGrupo" : intCveGrupo,
        "intTipoActa" : intTipoActa
    };  
    alert("Antes del ajax");
    $.ajax({
        data : parametros,
        url: 'calificacion_final/CancelarEnvioDeActaPorDirector.jsp',
        type : 'POST', 
        dataType: 'JSON',
        
        beforeSend : function(){            
            //$("#resultado").html("Procesando, espere por favor...");            
        },
        success : function(res)
        {
            console.log(res.intResultado);
            if(res.intResultado>0)
            {
                alert("SE CANCELO EL ENVÍO DEL ACTA SATISFACTORIAMENTE.");
            }
            else
            {
                alert("OCURRIO UN ERROR.");
            }
        }        
    });
//    location.reload();  //F5
//  form.submit();
}
*/

/************************************************************************************
    DESCRIPCION: Cancelar el envío de acta por parte del director
    CREADO POR: Nancy Alegría López
    FECHA: 01/04/2019
************************************************************************************/
function cancelarEnvioDeActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa)
{
//  alert("eNTRO A cancelarEnvioDeActaPorDirectorRRRR 2");
    if (confirm("ESTAS SEGURO DE QUE QUIERES CANCELAR EL ENVIO DEL ACTA DE CALIFICACIONES ORDINARIAS?") == true) 
    {

        var parametros = {
            "intCvePeriodo" : intCvePeriodo,
            "intCveCarrera" : intCveCarrera,
            "intCveGrupo" : intCveGrupo,
            "intTipoActa" : intTipoActa
        };  

        //console.log(parametros);
        //alert("Antes del ajax");
        $.ajax({
            data : parametros,
            url: "calificacion_final/CancelarEnvioDeActaPorDirector.jsp",
            type : "POST", 
            dataType: "JSON",
            
            success : function(res)
            {
          //      console.log(res.intResultado);
                //console.log(res.entro);
                //console.log(res);
                if(res.intResultado>0)
                {
                    alert("SE CANCELO EL ENVIO DEL ACTA SATISFACTORIAMENTE.");
                }
                else
                {
                    alert("OCURRIO UN ERROR.");
                }        
            }        
        });
//console.log("intTipoActa --" + intTipoActa);
        switch (intTipoActa) {
          case 1:
            mostrarSeccionOrdinarias(); 
            break;
          case 2:
            mostrarSeccionComplementarias();
            break;
          case 3:
            mostrarSeccionEspecialesRegularizacion();
            break;
          case 4:
            mostrarSeccionUltimaAsignatura();
            break;        
        }
        
    //    location.reload();  //F5
    //  form.submit();

    }//-->> Fin if confirm     
}

function FSalir()
{
    //alert("salir");
    location.href = "ini_evaluacion.jsp?menu=3&op=3";    
}

function fActualizaDivOrdinariasAlCerrar()
{
    //alert("prueba");
    mostrarSeccionOrdinarias();
    //window.close();
}

function fActualizaDivComplementariasAlCerrar()
{
    //alert("prueba");
    mostrarSeccionComplementarias();
    //window.close();
}

$(document).ready(() => FIniciar());


