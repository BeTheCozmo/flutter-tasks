import 'package:tasks/services/log_service.dart';

String parsePriority(String priority) {
  switch (priority) {
    case 'low': return 'Baixa';
    case 'mid': return 'Média';
    case 'high': return 'Alta';
    default:
      LogService.log('Prioridade não conhecida.');
      return priority;
  }
}

String parseStatus(String status) {
  switch (status) {
    case 'refinement': return 'Em refinamento';
    case 'todo': return 'Pronto para começar';
    case 'in progress': return 'Em progresso';
    case 'done': return 'Realizado';
    default:
      LogService.log('Status não conhecido.');
      return status;
  }
}