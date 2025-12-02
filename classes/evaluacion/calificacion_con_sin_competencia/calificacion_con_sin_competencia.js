//let correcto = $('#correcto');

$(document).on('ready',inicio);

function inicio(){
//alert("inicio");
/*
        if (correcto.val() > 0)
        {
            FCerrar();
        }
        
*/
        var intCvePeriodo = $('#intCvePeriodo').val();            
        var intCveCarrera = $('#intCveCarrera').val();            
        var intCveGrupo = $('#intCveGrupo').val();           
        var intTipoActa = $('#intTipoActa').val();
        var intCveDirector = $('#intCveDirector').val();
        var bandera_imprezion = $('#bandera_imprezion').val();     

        verificarActaFirmadaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa);


    $('#btnFirmarActa').click(function(){  

        if (confirm("ESTAS SEGURO DE QUE QUIERES FIRMAR EL ACTA DE CALIFICACIONES?") == true) 
        {
            //firmarActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa);
            firmarActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa,intCveDirector,bandera_imprezion);
        } 
    }); 

    $('#btnEnviarActaSe').click(function(){  

        if (confirm("ESTAS SEGURO DE QUE QUIERES AJUNTAR EL ACTA DE CALIFICACIONES PARA VALIDACION DE SERVICIOS ESCOLARES?") == true) 
        {
            adjuntarActaCalificaciones(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa);
        } 
    }); 


    $('#btnCancelarEnvioOrdinarias').click(function(){  

        if (confirm("ESTAS SEGURO DE QUE QUIERES CANCELAR EL ENVÍO DEL ACTA DE CALIFICACIONES ORDINARIAS?") == true) 
        {     
            alert("Cancelar ORDINARIAS");   
            //cancelarEnvioDeActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa);
        } 
    });         

/*
    $('#btnCerrar').click(function(){  
        alert("Llego a fCerrar");
        fCerrar();
    });         
*/
//fCerrar
}

function GuardarActa() 
{
    $('#modalFirmarGuardarEnviarActa').modal('hide');                                                               
//alert("Antes de display none");    
    $("#btnCerrar").css("display", "none");    //ocultar boton para que no se quede en el pdf    
    document.execCommand("print");   
}

/*
function FPantallaMenu()
{
    $('.modal-title').html("ACCIONES A REALIZAR POR EL DIRECTOR:");
    $('#modalFirmarGuardarEnviarActa').modal({show:true});                                                                                                                
}
*/

function Fimprimir ()
 {
    window.print();
}

function Fsalir()
{
    window.close();
}

/************************************************************************************
    DESCRIPCION: Verificar si el acta ordinaria ya esta firmada por el director    
    CREADO POR: Nancy Alegría López
    FECHA: 27/03/2019
************************************************************************************/
function verificarActaFirmadaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa)
{
    //alert("Entro a verificarActaFirmadaPorDirector");    
    var intTieneFechaActualizacion = $('#intTieneFechaActualizacion').val();             

    var parametros = {
        "intCvePeriodo" : intCvePeriodo,
        "intCveCarrera" : intCveCarrera,
        "intCveGrupo" : intCveGrupo,
        "intTipoActa" : intTipoActa
    };  
    
    $.ajax({
        data : parametros,
        url: 'calificacion_con_sin_competencia/VerificarActaFirmadaPorDirector.jsp',
        type : 'POST', 
        dataType: 'JSON',
        
        beforeSend : function(){            
            //$("#resultado").html("Procesando, espere por favor...");            
        },
        success : function(res)
        {
//              alert("Llego");                       
//            console.log("TieneFirmaActa --- " + res.intTieneFirmaActa);                    
//            console.log("intTieneFechaActualizacion" + intTieneFechaActualizacion);
//            if((res.intTieneFirmaActa>0)||(intTieneFechaActualizacion==0))    ---- HABILITAR ESO PARA PRODUCTIVO
            //-->> Verificar si ya se cuenta con fecha de ultima actualizacion
            if(intTieneFechaActualizacion>0)
            {
                if((res.intTieneFirmaActa>0)&&(res.intTieneEnvioDeActaPorDir>0))
                {
                    $("#btnFirmarActa").prop('disabled', true);  
                    $("#btnGuardarActa").prop('disabled', true);   
                    $("#btnEnviarActaSe").prop('disabled', true);   
                }
                else if(res.intTieneFirmaActa>0)
                     {
                        $("#btnFirmarActa").prop('disabled', true);         
                        $("#btnGuardarActa").prop('disabled', false);   
                        $("#btnEnviarActaSe").prop('disabled', false);   
                     } 
                     else if(res.intTieneEnvioDeActaPorDir>0)
                          {
                            $("#btnFirmarActa").prop('disabled', true); 
                            $("#btnGuardarActa").prop('disabled', true);   
                            $("#btnEnviarActaSe").prop('disabled', true);  
                          }
                          else
                          {
                            $("#btnFirmarActa").prop('disabled', false); 
                            $("#btnGuardarActa").prop('disabled', true);   
                            $("#btnEnviarActaSe").prop('disabled', true);   
                          }


            }
            else
            {
                alert("NO PUEDE FIRMA EL ACTA PORQUE NO SE CUENTA CON FECHA DE ULTIMA ACTUALIZACION. FAVOR DE VERIFICAR.");
            } //Fin if(intTieneFechaActualizacion>0)
        }        
    });
}


/************************************************************************************
    DESCRIPCION: Firma acta de calificaciones 
    CREADO POR: Nancy Alegría López
    FECHA: 29/03/2019
************************************************************************************/
function firmarActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa,intCveDirector,bandera_imprezion)
{
    /*
    console.log("ENTRO A firmarActaPorDirector");
    console.log(intCvePeriodo);
    console.log(intCveCarrera);
    console.log(intCveGrupo);
    console.log(intTipoActa);
*/
    var parametros = {
        "intCvePeriodo" : intCvePeriodo,
        "intCveCarrera" : intCveCarrera,
        "intCveGrupo" : intCveGrupo,
        "intTipoActa" : intTipoActa
    };  
    
    $.ajax({
        data : parametros,
        url: 'calificacion_con_sin_competencia/FirmarActaDeCalificaciones.jsp',
        type : 'POST', 
        dataType: 'JSON',
        
        beforeSend : function(){            
            //$("#resultado").html("Procesando, espere por favor...");            
        },
        success : function(res)
        {
            //console.log(res.Resultado);
            if(res.Resultado>0)
            {
                alert("SE FIRMO EL ACTA SATISFACTORIAMENTE.");
                //alert("hi");
//                location.reload();  //F5
                mostrarSeccionFirmaDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa, intCveDirector, bandera_imprezion);               
                verificarActaFirmadaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa);                
                //CierraPopupModal();
            }
            else
            {
                alert("OCURRIÓ UN ERROR.");
            }
        }        
    });
}

/************************************************************************************
    DESCRIPCION: Cancelar el envío de acta por parte del director
    CREADO POR: Nancy Alegría López
    FECHA: 01/04/2019
************************************************************************************/
function cancelarEnvioDeActaPorDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa)
{
 //alert("hi");   
    console.log("ENTRO A cancelarEnvioDeActaPorDirector");
    console.log(intCvePeriodo);
    console.log(intCveCarrera);
    console.log(intCveGrupo);
    console.log(intTipoActa);

    var parametros = {
        "intCvePeriodo" : intCvePeriodo,
        "intCveCarrera" : intCveCarrera,
        "intCveGrupo" : intCveGrupo,
        "intTipoActa" : intTipoActa
    };  
    
    $.ajax({
        data : parametros,
        url: 'calificacion_con_sin_competencia/CancelarEnvioDeActaPorDirector.jsp',
        type : 'POST', 
        dataType: 'JSON',
        
        beforeSend : function(){            
            //$("#resultado").html("Procesando, espere por favor...");            
        },
        success : function(res)
        {
            //console.log(res.Resultado);
            if(res.Resultado>0)
            {
                alert("SE CANCELÓ EL ENVÍO DEL ACTA SATISFACTORIAMENTE.");
            }
            else
            {
                alert("OCURRIÓ UN ERROR.");
            }
        }        
    });
}


function CierraPopupModal() 
{
  $("#modalFirmarGuardarEnviarActa").modal('hide');//ocultamos el modal
  $('body').removeClass('modal-open');//eliminamos la clase del body para poder hacer scroll
  $('.modal-backdrop').remove();//eliminamos el backdrop del modal
}

function AbrePopupModal() 
{
 // alert("Llego a AbrePopupModal");
  $("#modalFirmarGuardarEnviarActa").modal('show');//ocultamos el modal
//  $('body').removeClass('modal-open');//eliminamos la clase del body para poder hacer scroll
//  $('.modal-backdrop').remove();//eliminamos el backdrop del modal
}

function adjuntarActaCalificaciones(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa)
{/*
    alert("Llego a adjuntarActaCalificaciones");
    alert(intCvePeriodo);
    alert(intCveCarrera);
    alert(intCveGrupo);
    alert(intTipoActa);
*/
    CierraPopupModal();
//    var strNombreModal = "modalFirmarGuardarEnviarActa";
    var URL = "subir_acta_calif.jsp?intCvePeriodo=" + intCvePeriodo
    + "&intCveCarrera=" + intCveCarrera
    + "&intCveGrupo=" + intCveGrupo
    + "&intTipoActa=" + intTipoActa;
    
    ventana = window.open(URL,"subir_archivo","status=yes,scrollbars=yes,toolbar=yes,resizable=yes,width=600,height=450");    
}

function FActualizarPagina()
{
    location.reload();  //F5
}

function FCerrar()
{
    window.opener.fActualizaDivOrdinariasAlCerrar();
    window.close();
}

function mostrarSeccionFirmaDirector(intCvePeriodo,intCveCarrera,intCveGrupo,intTipoActa, intCveDirector, bandera_imprezion)
{
 /*   alert("Entro a mostrarSeccionFirmaDirector");

console.log("intCvePeriodo" + intCvePeriodo);
console.log("intCveCarrera" + intCveCarrera);
console.log("intCveGrupo" + intCveGrupo);
console.log("intTipoActa" + intTipoActa);
console.log("intCveDirector" + intCveDirector);
console.log("bandera_imprezion" + bandera_imprezion);*/
    var par = {
        "intCvePeriodo" : intCvePeriodo,
        "intCveCarrera" : intCveCarrera,
        "intCveGrupo" : intCveGrupo,
        "intTipoActa" : intTipoActa,
        "intCveDirector" : intCveDirector,
        "bandera_imprezion" : bandera_imprezion
    };  
//console.log("Antes del ajax");
            $.ajax({
                data: par,
                url: ('calificacion_con_sin_competencia/MostrarFirmaDirector.jsp'),
                type: 'POST',
                dataType: 'HTML',
                success: (res) => {
          //console.log('res => ', res);                                                                        
                            $('#FirmaElectronicaDir').html(res);
                        },
                        error: (err) => {
                            console.log('err => ', error);
                    
                            alert('Error al intentar recuperar la seccion de firma del director.');
                        }
                    });
}

