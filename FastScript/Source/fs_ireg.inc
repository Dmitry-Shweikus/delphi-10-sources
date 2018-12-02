
{******************************************}
{                                          }
{             FastScript v1.7              }
{               Include file               }
{                                          }
{ (c) 2003, 2004 by Alexander Tzyganenko,  }
{             Fast Reports, Inc            }
{                                          }
{******************************************}


//------------------- TeeChart component ----------------------------
{$DEFINE TeeChartStd}

//------------------- TeeChart Pro 4.5 component --------------------
// If you have TeeChart 4.5, uncomment the following line:
//{$DEFINE TeeChart45}

//------------------- TeeChart Pro 5.5 component --------------------
// If you have TeeChart 5.5, uncomment the following line:
//{$DEFINE TeeChart55}

//------------------- TeeChart Pro 6 component ----------------------
// If you have TeeChart 6, uncomment the following line:
//{$DEFINE TeeChart6}

//------------------- TeeChart Pro 6.6 component --------------------
// If you have TeeChart 6.6, uncomment the following line:
//{$DEFINE TeeChart66}

//------------------- TeeChart Pro 7 component ----------------------
// If you have TeeChart 7, uncomment the following line:
//{$DEFINE TeeChart7}

//------------------- TeeChart Pro 7/2005 component -----------------
//{$DEFINE TeeChart79}


// Don't change here ------------------------------------------------
{$IFDEF TeeChart45}
  {$UNDEF TeeChartStd}
{$ENDIF}

{$IFDEF TeeChart55}
  {$UNDEF TeeChartStd}
{$ENDIF}

{$IFDEF TeeChart6}
  {$UNDEF TeeChartStd}
{$ENDIF}

{$IFDEF TeeChart66}
  {$UNDEF TeeChartStd}
{$ENDIF}

{$IFDEF TeeChart7}
  {$UNDEF TeeChartStd}
{$ENDIF}

{$IFDEF TeeChart79}
  {$UNDEF TeeChartStd}
{$ENDIF}

